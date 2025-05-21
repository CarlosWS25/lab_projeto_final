from .connection import get_connection

def create_table():
    query = """
    CREATE TABLE IF NOT EXISTS users (
        id SERIAL PRIMARY KEY,
        name VARCHAR(100) NOT NULL,
        email VARCHAR(100) UNIQUE NOT NULL,
        password VARCHAR(255) NOT NULL
    );
    """
    conn = get_connection()
    if conn:
        with conn.cursor() as cur:
            cur.execute(query)
            conn.commit()
            print("Tabela 'users' criada.")
        conn.close()

