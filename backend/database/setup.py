from .connection import get_connection

def create_table_users():
    query = """
    CREATE TABLE IF NOT EXISTS users (
        is_admin BOOLEAN DEFAULT FALSE NOT NULL,
        id SERIAL PRIMARY KEY,
        username VARCHAR(100) NOT NULL,
        password VARCHAR(255) NOT NULL,
        ano_nascimento INTEGER,
        altura_cm INTEGER,
        peso REAL,
        genero CHAR(1),
        recovery_key VARCHAR(255)
    );
    """

    conn = get_connection()
    if conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            print("Tabela 'users' atualizada.")
        conn.close()


def create_table_saude():
    query = """
    CREATE TABLE IF NOT EXISTS saude (
        id SERIAL PRIMARY KEY,
        doencas TEXT[],
        sintomas TEXT[],
        droga_usada VARCHAR(100),
        quantidade REAL,
        idade_atual INTEGER,
        peso REAL,
        altura_cm INTEGER,
        genero CHAR(1)
    );
    """

    conn = get_connection()
    if conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            print("Tabela 'saude' atualizada.")
        conn.close()
