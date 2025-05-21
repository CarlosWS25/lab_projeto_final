import psycopg2

DB_CONFIG = {
    'host': 'localhost',
    'port': '5432',
    'dbname': 'dosewise',
    'user': 'postgres',
    'password': '248624'
}

def get_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print("Erro ao ligar à base de dados:", e)
        return None
