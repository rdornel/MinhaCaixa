"""
Sistema de Cadastro - Banco MinhaCaixa (versão Web)
=====================================================
Aplicação Flask para cadastro de Clientes e lançamento de Movimentos
(débito/crédito) em contas existentes.

Requisitos:
    pip install -r requirements.txt

Antes de rodar, ajuste as configurações de conexão em db.py.

Execução:
    python app.py
    (acesse http://localhost:5000)
"""

from datetime import date, datetime

from flask import Flask, render_template, request, redirect, url_for, flash

import data

app = Flask(__name__)
app.secret_key = "troque-esta-chave-em-producao"


# ------------------------------------------------------------------ Home

@app.route("/")
def index():
    return redirect(url_for("clientes_listar"))


# --------------------------------------------------------------- Clientes

@app.route("/clientes")
def clientes_listar():
    termo = request.args.get("q", "").strip()
    try:
        linhas = data.cliente_buscar(termo) if termo else data.cliente_buscar("")
    except Exception as e:
        flash(f"Erro ao buscar clientes: {e}", "danger")
        linhas = []
    return render_template("clientes_lista.html", clientes=linhas, termo=termo)


@app.route("/clientes/novo", methods=["GET", "POST"])
def clientes_novo():
    if request.method == "POST":
        try:
            dados = data.cliente_validar(request.form)
            codigo = data.cliente_inserir(dados)
            flash(f"Cliente cadastrado com código {codigo}.", "success")
            return redirect(url_for("clientes_listar"))
        except ValueError as e:
            flash(str(e), "warning")
        except Exception as e:
            flash(f"Erro ao salvar cliente: {e}", "danger")
    return render_template(
        "cliente_form.html",
        campos=data.CLIENTE_CAMPOS,
        cliente=None,
        titulo="Novo Cliente",
    )


@app.route("/clientes/<int:codigo>/editar", methods=["GET", "POST"])
def clientes_editar(codigo):
    if request.method == "POST":
        try:
            dados = data.cliente_validar(request.form)
            data.cliente_atualizar(codigo, dados)
            flash(f"Cliente {codigo} atualizado.", "success")
            return redirect(url_for("clientes_listar"))
        except ValueError as e:
            flash(str(e), "warning")
        except Exception as e:
            flash(f"Erro ao atualizar cliente: {e}", "danger")

    cliente = data.cliente_obter_por_codigo(codigo)
    if cliente is None:
        flash("Cliente não encontrado.", "warning")
        return redirect(url_for("clientes_listar"))

    if cliente.get("ClienteNascimento"):
        cliente["ClienteNascimento"] = cliente["ClienteNascimento"].strftime("%Y-%m-%d")

    return render_template(
        "cliente_form.html",
        campos=data.CLIENTE_CAMPOS,
        cliente=cliente,
        titulo=f"Editar Cliente #{codigo}",
    )


# ------------------------------------------------------------- Movimentos

@app.route("/movimentos", methods=["GET"])
def movimentos_home():
    try:
        contas = data.contas_listar()
    except Exception as e:
        flash(f"Erro ao carregar contas: {e}", "danger")
        contas = []

    try:
        tipos = data.tipos_movimento_listar()
    except Exception as e:
        flash(f"Erro ao carregar tipos de movimento: {e}", "danger")
        tipos = []

    conta_selecionada = request.args.get("conta", "")
    movimentos = []
    if conta_selecionada:
        try:
            movimentos = data.movimentos_listar_por_conta(conta_selecionada)
        except Exception as e:
            flash(f"Erro ao listar movimentos: {e}", "danger")

    return render_template(
        "movimentos.html",
        contas=contas,
        tipos=tipos,
        conta_selecionada=conta_selecionada,
        movimentos=movimentos,
        hoje=date.today().strftime("%Y-%m-%d"),
    )


@app.route("/movimentos/novo", methods=["POST"])
def movimentos_novo():
    conta_numero = request.form.get("conta_numero", "").strip()
    data_str = request.form.get("data", "").strip()
    valor_str = request.form.get("valor", "").strip()
    tipo_str = request.form.get("tipo", "").strip()

    if not conta_numero:
        flash("Selecione uma conta.", "warning")
        return redirect(url_for("movimentos_home"))

    try:
        data_mov = datetime.strptime(data_str, "%Y-%m-%d")
    except ValueError:
        flash("Data inválida. Use o formato AAAA-MM-DD.", "warning")
        return redirect(url_for("movimentos_home", conta=conta_numero))

    try:
        valor = float(valor_str.replace(",", "."))
        if valor <= 0:
            raise ValueError
    except ValueError:
        flash("Informe um valor numérico maior que zero.", "warning")
        return redirect(url_for("movimentos_home", conta=conta_numero))

    try:
        tipo_codigo = int(tipo_str)
    except ValueError:
        flash("Selecione o tipo de movimento.", "warning")
        return redirect(url_for("movimentos_home", conta=conta_numero))

    try:
        codigo = data.movimento_inserir(conta_numero, data_mov, valor, tipo_codigo)
        flash(f"Movimento {codigo} lançado com sucesso.", "success")
    except Exception as e:
        flash(f"Erro ao lançar movimento: {e}", "danger")

    return redirect(url_for("movimentos_home", conta=conta_numero))


if __name__ == "__main__":
    app.run(debug=True)
