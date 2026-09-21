"""
Sistema de Cadastro - Banco MinhaCaixa
========================================
Interface gráfica (Tkinter) para cadastro de Clientes e lançamento de
Movimentos (débito/crédito) em contas existentes.

Requisitos:
    pip install pyodbc

Antes de rodar, ajuste as configurações de conexão em db.py.

Execução:
    python main.py
"""

import tkinter as tk
from tkinter import ttk, messagebox
from datetime import datetime, date

from db import get_connection


# ============================================================
# Camada de acesso a dados (CRUD)
# ============================================================

CLIENTE_CAMPOS = [
    ("ClienteCPF", "CPF"),
    ("ClienteNome", "Nome"),
    ("ClienteSobrenome", "Sobrenome"),
    ("ClienteSexo", "Sexo (M/F)"),
    ("ClienteNascimento", "Nascimento (AAAA-MM-DD)"),
    ("ClienteEstadoCivil", "Estado Civil (S/C)"),
    ("ClienteRua", "Rua"),
    ("ClienteNumero", "Número"),
    ("ClienteBairro", "Bairro"),
    ("ClienteCEP", "CEP"),
    ("ClienteCidade", "Cidade"),
    ("ClienteEstado", "Estado"),
    ("ClientePais", "País"),
    ("ClienteRendaAnual", "Renda Anual"),
    ("ClienteTelefone", "Telefone"),
    ("ClienteEmail", "E-mail"),
]


def cliente_inserir(dados: dict) -> int:
    campos = [c for c, _ in CLIENTE_CAMPOS]
    placeholders = ", ".join("?" for _ in campos)
    colunas = ", ".join(campos)
    sql = f"INSERT INTO dbo.Clientes ({colunas}) OUTPUT INSERTED.ClienteCodigo VALUES ({placeholders})"
    valores = [dados.get(c) for c in campos]
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, valores)
        novo_codigo = cur.fetchone()[0]
        conn.commit()
        return novo_codigo


def cliente_atualizar(codigo: int, dados: dict) -> None:
    campos = [c for c, _ in CLIENTE_CAMPOS]
    set_clause = ", ".join(f"{c} = ?" for c in campos)
    sql = f"UPDATE dbo.Clientes SET {set_clause} WHERE ClienteCodigo = ?"
    valores = [dados.get(c) for c in campos] + [codigo]
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, valores)
        conn.commit()


def cliente_buscar(termo: str):
    """Busca por código exato, ou por nome/sobrenome/CPF (LIKE)."""
    sql = """
        SELECT ClienteCodigo, ClienteCPF, ClienteNome, ClienteSobrenome,
               ClienteCidade, ClienteTelefone, ClienteEmail
        FROM dbo.Clientes
        WHERE CAST(ClienteCodigo AS VARCHAR(20)) = ?
           OR ClienteNome LIKE ?
           OR ClienteSobrenome LIKE ?
           OR ClienteCPF LIKE ?
        ORDER BY ClienteCodigo
    """
    like = f"%{termo}%"
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, [termo, like, like, like])
        return cur.fetchall()


def cliente_obter_por_codigo(codigo: int):
    campos = [c for c, _ in CLIENTE_CAMPOS]
    colunas = ", ".join(campos)
    sql = f"SELECT ClienteCodigo, {colunas} FROM dbo.Clientes WHERE ClienteCodigo = ?"
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, [codigo])
        return cur.fetchone()


def contas_listar():
    """Lista contas para preencher o combobox de Movimentos."""
    sql = """
        SELECT c.ContaNumero, cl.ClienteNome, cl.ClienteSobrenome
        FROM dbo.Contas c
        JOIN dbo.Clientes cl ON cl.ClienteCodigo = c.ClienteCodigo
        ORDER BY c.ContaNumero
    """
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql)
        return cur.fetchall()


def tipos_movimento_listar():
    sql = "SELECT TipoMovimentoCodigo, TipoMovimentoDescricao FROM dbo.TipoMovimento ORDER BY TipoMovimentoCodigo"
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql)
        return cur.fetchall()


def movimento_inserir(conta_numero: str, data_mov, valor: float, tipo_codigo: int) -> int:
    sql = """
        INSERT INTO dbo.Movimentos (ContaNumero, MovimentoData, MovimentoValor, MovimentoTipo)
        OUTPUT INSERTED.MovimentoCodigo
        VALUES (?, ?, ?, ?)
    """
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, [conta_numero, data_mov, valor, tipo_codigo])
        novo_codigo = cur.fetchone()[0]
        conn.commit()
        return novo_codigo


def movimentos_listar_por_conta(conta_numero: str):
    sql = """
        SELECT m.MovimentoCodigo, m.MovimentoData, m.MovimentoValor, t.TipoMovimentoDescricao
        FROM dbo.Movimentos m
        JOIN dbo.TipoMovimento t ON t.TipoMovimentoCodigo = m.MovimentoTipo
        WHERE m.ContaNumero = ?
        ORDER BY m.MovimentoData DESC, m.MovimentoCodigo DESC
    """
    with get_connection() as conn:
        cur = conn.cursor()
        cur.execute(sql, [conta_numero])
        return cur.fetchall()


# ============================================================
# Interface gráfica
# ============================================================

class ClientesFrame(ttk.Frame):
    def __init__(self, master):
        super().__init__(master, padding=10)
        self.codigo_atual = None
        self.entries = {}
        self._montar_formulario()
        self._montar_busca_e_lista()

    def _montar_formulario(self):
        form = ttk.LabelFrame(self, text="Dados do Cliente")
        form.grid(row=0, column=0, sticky="nsew", padx=(0, 10))

        for i, (campo, rotulo) in enumerate(CLIENTE_CAMPOS):
            ttk.Label(form, text=rotulo).grid(row=i, column=0, sticky="w", padx=4, pady=2)
            ent = ttk.Entry(form, width=35)
            ent.grid(row=i, column=1, padx=4, pady=2)
            self.entries[campo] = ent

        botoes = ttk.Frame(form)
        botoes.grid(row=len(CLIENTE_CAMPOS), column=0, columnspan=2, pady=10)
        ttk.Button(botoes, text="Novo", command=self.novo).pack(side="left", padx=4)
        ttk.Button(botoes, text="Salvar", command=self.salvar).pack(side="left", padx=4)

        self.lbl_status = ttk.Label(form, text="", foreground="green")
        self.lbl_status.grid(row=len(CLIENTE_CAMPOS) + 1, column=0, columnspan=2)

    def _montar_busca_e_lista(self):
        lado = ttk.Frame(self)
        lado.grid(row=0, column=1, sticky="nsew")

        busca_frame = ttk.Frame(lado)
        busca_frame.pack(fill="x")
        ttk.Label(busca_frame, text="Buscar (código, nome, sobrenome ou CPF):").pack(side="left")
        self.busca_var = tk.StringVar()
        ttk.Entry(busca_frame, textvariable=self.busca_var, width=25).pack(side="left", padx=4)
        ttk.Button(busca_frame, text="Buscar", command=self.buscar).pack(side="left")

        colunas = ("codigo", "cpf", "nome", "sobrenome", "cidade", "telefone", "email")
        self.tree = ttk.Treeview(lado, columns=colunas, show="headings", height=25)
        for c, largura in zip(colunas, (60, 110, 100, 100, 100, 110, 160)):
            self.tree.heading(c, text=c.capitalize())
            self.tree.column(c, width=largura)
        self.tree.pack(fill="both", expand=True, pady=8)
        self.tree.bind("<Double-1>", self._carregar_selecionado)

    def novo(self):
        self.codigo_atual = None
        for ent in self.entries.values():
            ent.delete(0, tk.END)
        self.lbl_status.config(text="")

    def _validar(self) -> dict:
        dados = {}
        for campo, rotulo in CLIENTE_CAMPOS:
            valor = self.entries[campo].get().strip()
            if campo == "ClienteNome" and not valor:
                raise ValueError("O campo Nome é obrigatório.")
            if campo == "ClienteNumero" and valor:
                try:
                    valor = int(valor)
                except ValueError:
                    raise ValueError("Número do endereço deve ser inteiro.")
            if campo == "ClienteRendaAnual" and valor:
                try:
                    valor = float(valor.replace(",", "."))
                except ValueError:
                    raise ValueError("Renda Anual deve ser numérica.")
            if campo == "ClienteNascimento" and valor:
                try:
                    valor = datetime.strptime(valor, "%Y-%m-%d")
                except ValueError:
                    raise ValueError("Data de nascimento deve estar no formato AAAA-MM-DD.")
            dados[campo] = valor if valor != "" else None
        return dados

    def salvar(self):
        try:
            dados = self._validar()
        except ValueError as e:
            messagebox.showwarning("Validação", str(e))
            return
        try:
            if self.codigo_atual is None:
                novo_codigo = cliente_inserir(dados)
                self.codigo_atual = novo_codigo
                self.lbl_status.config(text=f"Cliente cadastrado com código {novo_codigo}.")
            else:
                cliente_atualizar(self.codigo_atual, dados)
                self.lbl_status.config(text=f"Cliente {self.codigo_atual} atualizado.")
            self.buscar()
        except Exception as e:
            messagebox.showerror("Erro ao salvar", str(e))

    def buscar(self):
        termo = self.busca_var.get().strip()
        if not termo:
            termo = ""
        try:
            linhas = cliente_buscar(termo)
        except Exception as e:
            messagebox.showerror("Erro na busca", str(e))
            return
        for item in self.tree.get_children():
            self.tree.delete(item)
        for linha in linhas:
            self.tree.insert("", "end", values=tuple(linha))

    def _carregar_selecionado(self, event):
        item = self.tree.selection()
        if not item:
            return
        codigo = self.tree.item(item[0])["values"][0]
        registro = cliente_obter_por_codigo(codigo)
        if not registro:
            return
        self.codigo_atual = registro[0]
        for i, (campo, _) in enumerate(CLIENTE_CAMPOS, start=1):
            valor = registro[i]
            self.entries[campo].delete(0, tk.END)
            if valor is not None:
                if isinstance(valor, (datetime, date)):
                    self.entries[campo].insert(0, valor.strftime("%Y-%m-%d"))
                else:
                    self.entries[campo].insert(0, str(valor))
        self.lbl_status.config(text=f"Editando cliente {self.codigo_atual}.")


class MovimentosFrame(ttk.Frame):
    def __init__(self, master):
        super().__init__(master, padding=10)
        self._montar()

    def _montar(self):
        form = ttk.LabelFrame(self, text="Novo Movimento")
        form.grid(row=0, column=0, sticky="nsew", padx=(0, 10))

        ttk.Label(form, text="Conta:").grid(row=0, column=0, sticky="w", padx=4, pady=4)
        self.conta_var = tk.StringVar()
        self.conta_combo = ttk.Combobox(form, textvariable=self.conta_var, width=45, state="readonly")
        self.conta_combo.grid(row=0, column=1, padx=4, pady=4)
        self._contas_map = {}
        self._carregar_contas()
        self.conta_combo.bind("<<ComboboxSelected>>", lambda e: self._listar_movimentos())

        ttk.Label(form, text="Data (AAAA-MM-DD):").grid(row=1, column=0, sticky="w", padx=4, pady=4)
        self.data_entry = ttk.Entry(form, width=20)
        self.data_entry.insert(0, date.today().strftime("%Y-%m-%d"))
        self.data_entry.grid(row=1, column=1, sticky="w", padx=4, pady=4)

        ttk.Label(form, text="Valor:").grid(row=2, column=0, sticky="w", padx=4, pady=4)
        self.valor_entry = ttk.Entry(form, width=20)
        self.valor_entry.grid(row=2, column=1, sticky="w", padx=4, pady=4)

        ttk.Label(form, text="Tipo:").grid(row=3, column=0, sticky="w", padx=4, pady=4)
        self.tipo_var = tk.StringVar()
        self.tipo_combo = ttk.Combobox(form, textvariable=self.tipo_var, width=20, state="readonly")
        self.tipo_combo.grid(row=3, column=1, sticky="w", padx=4, pady=4)
        self._tipos_map = {}
        self._carregar_tipos()

        ttk.Button(form, text="Lançar Movimento", command=self.salvar).grid(
            row=4, column=0, columnspan=2, pady=10
        )
        self.lbl_status = ttk.Label(form, text="", foreground="green")
        self.lbl_status.grid(row=5, column=0, columnspan=2)

        lado = ttk.Frame(self)
        lado.grid(row=0, column=1, sticky="nsew")
        ttk.Label(lado, text="Movimentos da conta selecionada:").pack(anchor="w")
        colunas = ("codigo", "data", "valor", "tipo")
        self.tree = ttk.Treeview(lado, columns=colunas, show="headings", height=25)
        for c, largura in zip(colunas, (70, 110, 100, 100)):
            self.tree.heading(c, text=c.capitalize())
            self.tree.column(c, width=largura)
        self.tree.pack(fill="both", expand=True, pady=8)

    def _carregar_contas(self):
        try:
            linhas = contas_listar()
        except Exception as e:
            messagebox.showerror("Erro ao carregar contas", str(e))
            return
        valores = []
        self._contas_map = {}
        for numero, nome, sobrenome in linhas:
            rotulo = f"{numero} - {nome} {sobrenome}"
            valores.append(rotulo)
            self._contas_map[rotulo] = numero
        self.conta_combo["values"] = valores

    def _carregar_tipos(self):
        try:
            linhas = tipos_movimento_listar()
        except Exception as e:
            messagebox.showerror("Erro ao carregar tipos", str(e))
            return
        valores = []
        self._tipos_map = {}
        for codigo, descricao in linhas:
            valores.append(descricao)
            self._tipos_map[descricao] = codigo
        self.tipo_combo["values"] = valores
        if valores:
            self.tipo_combo.current(0)

    def _listar_movimentos(self):
        rotulo = self.conta_var.get()
        conta_numero = self._contas_map.get(rotulo)
        if not conta_numero:
            return
        try:
            linhas = movimentos_listar_por_conta(conta_numero)
        except Exception as e:
            messagebox.showerror("Erro ao listar movimentos", str(e))
            return
        for item in self.tree.get_children():
            self.tree.delete(item)
        for codigo, data_mov, valor, tipo in linhas:
            data_fmt = data_mov.strftime("%Y-%m-%d") if data_mov else ""
            self.tree.insert("", "end", values=(codigo, data_fmt, f"{valor:.2f}", tipo))

    def salvar(self):
        rotulo_conta = self.conta_var.get()
        conta_numero = self._contas_map.get(rotulo_conta)
        if not conta_numero:
            messagebox.showwarning("Validação", "Selecione uma conta.")
            return

        try:
            data_mov = datetime.strptime(self.data_entry.get().strip(), "%Y-%m-%d")
        except ValueError:
            messagebox.showwarning("Validação", "Data inválida. Use o formato AAAA-MM-DD.")
            return

        try:
            valor = float(self.valor_entry.get().strip().replace(",", "."))
            if valor <= 0:
                raise ValueError
        except ValueError:
            messagebox.showwarning("Validação", "Informe um valor numérico maior que zero.")
            return

        tipo_desc = self.tipo_var.get()
        tipo_codigo = self._tipos_map.get(tipo_desc)
        if tipo_codigo is None:
            messagebox.showwarning("Validação", "Selecione o tipo de movimento.")
            return

        try:
            codigo = movimento_inserir(conta_numero, data_mov, valor, tipo_codigo)
            self.lbl_status.config(text=f"Movimento {codigo} lançado com sucesso.")
            self.valor_entry.delete(0, tk.END)
            self._listar_movimentos()
        except Exception as e:
            messagebox.showerror("Erro ao lançar movimento", str(e))


class App(tk.Tk):
    def __init__(self):
        super().__init__()
        self.title("MinhaCaixa - Cadastro de Clientes e Movimentos")
        self.geometry("1150x650")

        notebook = ttk.Notebook(self)
        notebook.pack(fill="both", expand=True)

        aba_clientes = ClientesFrame(notebook)
        aba_movimentos = MovimentosFrame(notebook)

        notebook.add(aba_clientes, text="Clientes")
        notebook.add(aba_movimentos, text="Movimentos")


if __name__ == "__main__":
    app = App()
    app.mainloop()
