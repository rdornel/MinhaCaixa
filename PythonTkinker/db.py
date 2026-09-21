"""
Módulo de conexão com o banco de dados MinhaCaixa (SQL Server).

Requer o driver ODBC "ODBC Driver 17 for SQL Server" (ou 18) instalado
no sistema, e a biblioteca pyodbc (pip install pyodbc).
"""

import pyodbc

# ----------------------------------------------------------------------
# Ajuste estas configurações de acordo com o seu ambiente.
# ----------------------------------------------------------------------
DB_CONFIG = {
    "driver": "{ODBC Driver 17 for SQL Server}",
    "server": "localhost",        # ex: "localhost\\SQLEXPRESS" ou IP do servidor
    "database": "MinhaCaixa",
    "trusted_connection": "yes",  # usa autenticação do Windows
    # Caso use autenticação SQL Server, comente a linha acima e use:
    # "uid": "seu_usuario",
    # "pwd": "sua_senha",
}


def get_connection():
    """Retorna uma nova conexão pyodbc com o banco MinhaCaixa."""
    if DB_CONFIG.get("trusted_connection") == "yes":
        conn_str = (
            f"DRIVER={DB_CONFIG['driver']};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"Trusted_Connection=yes;"
        )
    else:
        conn_str = (
            f"DRIVER={DB_CONFIG['driver']};"
            f"SERVER={DB_CONFIG['server']};"
            f"DATABASE={DB_CONFIG['database']};"
            f"UID={DB_CONFIG['uid']};"
            f"PWD={DB_CONFIG['pwd']};"
        )
    return pyodbc.connect(conn_str)
