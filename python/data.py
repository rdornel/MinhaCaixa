"""
Camada de acesso a dados para Clientes, Contas e Movimentos.
Usada pelas rotas Flask em app.py.
"""

from datetime import datetime
from db import get_connection

CLIENTE_CAMPOS = [
    ("ClienteCPF", "CPF"),
    ("ClienteNome", "Nome"),
    ("ClienteSobrenome", "Sobrenome"),
    ("ClienteSexo", "Sexo (M/F)"),
    ("ClienteNascimento", "Nascimento"),
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


# ---------------------------------------------------------------- Clientes

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
        row = cur.fetchone()
        if not row:
            return None
        resultado = {"ClienteCodigo": row[0]}
        for i, (campo, _) in enumerate(CLIENTE_CAMPOS, start=1):
            resultado[campo] = row[i]
        return resultado


def cliente_validar(form: dict) -> dict:
    """Valida e converte os dados vindos do formulário HTML."""
    dados = {}
    for campo, rotulo in CLIENTE_CAMPOS:
        valor = (form.get(campo) or "").strip()

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
                raise ValueError("Data de nascimento inválida.")

        dados[campo] = valor if valor != "" else None
    return dados


# ------------------------------------------------------------------ Contas

def contas_listar():
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


# -------------------------------------------------------------- Movimentos

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
