from .connection import get_connection

def create_table():
    query = """
    CREATE TABLE IF NOT EXISTS users (
        is_admin BOOLEAN DEFAULT FALSE NOT NULL,
        id SERIAL PRIMARY KEY,
        username VARCHAR(100) NOT NULL,
        password VARCHAR(255) NOT NULL,
        ano_nascimento INTEGER,
        altura_cm INTEGER,
        peso REAL,
        genero CHAR(1)
        
    );
    """

    conn = get_connection()
    if conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            print("Tabela 'users' atualizada.")
        conn.close()
