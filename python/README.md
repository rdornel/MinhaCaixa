# Cadastro MinhaCaixa — Versão Web (Flask)

Aplicação web em **Flask** (Python) para cadastro de Clientes e lançamento
de Movimentos (débito/crédito), usando o banco SQL Server `MinhaCaixa`.

Reaproveita a mesma lógica de negócio da versão desktop, agora servida
via navegador com Bootstrap 5.

## Estrutura

```
cadastro_web/
├── app.py                     # rotas Flask
├── data.py                    # camada de acesso a dados (SQL)
├── db.py                      # conexão com SQL Server
├── requirements.txt
└── templates/
    ├── base.html               # layout + menu
    ├── clientes_lista.html      # listagem/busca de clientes
    ├── cliente_form.html        # cadastro/edição de cliente
    └── movimentos.html          # lançamento + histórico de movimentos
```

## Pré-requisitos

1. **Driver ODBC** para SQL Server (ex.: "ODBC Driver 17 for SQL Server").
   - Windows/Mac: instalador da Microsoft.
   - Linux (Debian/Ubuntu): `apt-get install unixodbc` + o pacote
     `msodbcsql17` da Microsoft.
2. Python 3.9+.
3. Instalar dependências:
   ```bash
   pip install -r requirements.txt
   ```

## Configuração da conexão

Edite `db.py` e ajuste `DB_CONFIG` (mesmo padrão da versão desktop):

```python
DB_CONFIG = {
    "driver": "{ODBC Driver 17 for SQL Server}",
    "server": "localhost",        # ou "SEUSERVIDOR\\SQLEXPRESS"
    "database": "MinhaCaixa",
    "trusted_connection": "yes",  # autenticação Windows
}
```

Para autenticação SQL Server (usuário/senha), troque
`trusted_connection` para `"no"` e preencha `uid`/`pwd`.

## Executando

```bash
python app.py
```

Acesse **http://localhost:5000** no navegador.

## Rotas principais

| Rota                          | Método   | Descrição                                   |
|--------------------------------|----------|----------------------------------------------|
| `/clientes`                    | GET      | Lista/busca clientes                          |
| `/clientes/novo`               | GET/POST | Formulário de novo cliente                    |
| `/clientes/<codigo>/editar`    | GET/POST | Formulário de edição de cliente               |
| `/movimentos`                  | GET      | Formulário de lançamento + histórico          |
| `/movimentos/novo`             | POST     | Insere um novo movimento (débito/crédito)     |

## Observações

- A interface usa Bootstrap via CDN (não requer build de front-end).
- Datas são digitadas em campos `<input type="date">` do navegador.
- Valores monetários aceitam ponto ou vírgula como separador decimal.
- Para produção, troque `app.secret_key` em `app.py` por um valor
  seguro e desative `debug=True`.
- As rotas foram testadas com o cliente de testes do Flask usando dados
  simulados (sem necessidade de um SQL Server real disponível).
