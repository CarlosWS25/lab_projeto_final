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
        doenca_pre_existente VARCHAR(255),
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


def create_table_friends():
    query = """
    CREATE TABLE IF NOT EXISTS friends (
        user_id INTEGER NOT NULL,
        nome_do_amigo VARCHAR(100) NOT NULL,
        numero_amigo VARCHAR(20) NOT NULL
    );
    """

    conn = get_connection()
    if conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            print("Tabela 'friends' atualizada.")
        conn.close()