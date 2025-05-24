from .connection import get_connection
from utils.hash import hash_password

# CREATE
def insert_user(is_admin, username, password, altura_cm, peso, genero, outras_doencas="não", doencas="nenhuma"):
    hashed_pw = hash_password(password)
    query = """
    INSERT INTO users (
        is_admin,
        username,
        password,
        altura_cm,
        peso,
        genero,
        outras_doencas,
        doencas
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s);
    """
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (is_admin, username, hashed_pw, altura_cm, peso, genero, outras_doencas, doencas))
                conn.commit()
                print("✅ Utilizador inserido com sucesso.")
        except Exception as e:
            print("❌ Erro ao inserir:", e)
        finally:
            conn.close()

# READ all
def get_all_users():
    query = "SELECT is_admin, id, username, altura_cm, peso, genero, outras_doencas, doencas FROM users ORDER BY id;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query)
                return cur.fetchall()
        except Exception as e:
            print("❌ Erro ao ler utilizadores:", e)
        finally:
            conn.close()
    return []

# READ by id
def get_user_by_id(user_id):
    query = "SELECT is_admin, id, username, altura_cm, peso, genero, outras_doencas, doencas FROM users WHERE id = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (user_id,))
                return cur.fetchone()
        except Exception as e:
            print("❌ Erro ao obter utilizador:", e)
        finally:
            conn.close()
    return None

# UPDATE
def update_user(
    user_id,
    username=None,
    password=None,
    altura_cm=None,
    peso=None,
    genero=None,
    outras_doencas=None,
    doencas=None,
    is_admin=None
):
    conn = get_connection()
    if conn:
        try:
            updates = []
            values = []

            if username is not None:
                updates.append("username = %s")
                values.append(username)
            if password is not None:
                updates.append("password = %s")
                values.append(hash_password(password))
            if altura_cm is not None:
                updates.append("altura_cm = %s")
                values.append(altura_cm)
            if peso is not None:
                updates.append("peso = %s")
                values.append(peso)
            if genero is not None:
                updates.append("genero = %s")
                values.append(genero)
            if outras_doencas is not None:
                updates.append("outras_doencas = %s")
                values.append(outras_doencas)
            if doencas is not None:
                updates.append("doencas = %s")
                values.append(doencas)
            if is_admin is not None:
                updates.append("is_admin = %s")
                values.append(is_admin)

            if not updates:
                return False

            values.append(user_id)
            query = f"UPDATE users SET {', '.join(updates)} WHERE id = %s;"
            with conn.cursor() as cur:
                cur.execute(query, tuple(values))
                conn.commit()
                return True
        except Exception as e:
            print("❌ Erro ao atualizar utilizador:", e)
        finally:
            conn.close()
    return False

# DELETE
def delete_user(user_id):
    query = "DELETE FROM users WHERE id = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (user_id,))
                conn.commit()
                return True
        except Exception as e:
            print("❌ Erro ao apagar utilizador:", e)
        finally:
            conn.close()
    return False

# Lookup for login
def get_user_by_username(username):
    query = "SELECT is_admin, id, username, password FROM users WHERE username = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (username,))
                return cur.fetchone()
        except Exception as e:
            print("❌ Erro ao buscar utilizador:", e)
        finally:
            conn.close()
    return None
