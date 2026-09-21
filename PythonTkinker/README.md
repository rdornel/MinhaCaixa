# Cadastro MinhaCaixa (Clientes e Movimentos)

Interface desktop em **Python + Tkinter** para cadastrar Clientes e lançar
Movimentos (débito/crédito), usando o banco SQL Server `MinhaCaixa` criado
pelo script que você enviou.

## Arquivos

- `db.py` — configuração e abertura da conexão com o SQL Server (via `pyodbc`).
- `main.py` — aplicação gráfica (duas abas: **Clientes** e **Movimentos**).
- `requirements.txt` — dependências Python.

## Pré-requisitos

1. **Driver ODBC** para SQL Server instalado no sistema
   (ex.: "ODBC Driver 17 for SQL Server" — baixe da Microsoft).
2. Python 3.9+.
3. Instalar dependência:
   ```bash
   pip install -r requirements.txt
   ```

## Configuração da conexão

Edite `db.py` e ajuste `DB_CONFIG`:

```python
DB_CONFIG = {
    "driver": "{ODBC Driver 17 for SQL Server}",
    "server": "localhost",        # ou "SEUSERVIDOR\\SQLEXPRESS"
    "database": "MinhaCaixa",
    "trusted_connection": "yes",  # autenticação Windows
}
```

Se preferir autenticação SQL Server (usuário/senha), troque
`trusted_connection` para `"no"` e preencha `uid`/`pwd`.

## Executando

```bash
python main.py
```

## O que a aplicação faz

### Aba Clientes
- Formulário com todos os campos da tabela `dbo.Clientes`.
- **Novo**: limpa o formulário para um novo cadastro.
- **Salvar**: insere um novo cliente (se nenhum estiver selecionado) ou
  atualiza o cliente carregado.
- Busca por código, nome, sobrenome ou CPF, com resultados em lista.
- Duplo clique num resultado carrega o registro no formulário para edição.

### Aba Movimentos
- Combobox com as contas existentes (`dbo.Contas`), já mostrando o nome
  do titular.
- Campos de Data, Valor e Tipo (Débito/Crédito, vindos de
  `dbo.TipoMovimento`).
- **Lançar Movimento**: insere na tabela `dbo.Movimentos`.
- Ao selecionar uma conta, o histórico de movimentos daquela conta é
  exibido à direita.

## Observações

- Datas devem ser digitadas no formato `AAAA-MM-DD`.
- Valores monetários aceitam ponto ou vírgula como separador decimal.
- O `ClienteCodigo` e o `MovimentoCodigo` são gerados automaticamente pelo
  banco (colunas `IDENTITY`), então não aparecem como campos editáveis.
