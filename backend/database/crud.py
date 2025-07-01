from .connection import get_connection
from utils.hash import hash_password, verify_password
import datetime
import random
import string


def gen_recovery_key(size=6):
    caracteres = string.ascii_letters + string.digits 
    return ''.join(random.choices(caracteres, k=size))

def insert_user(is_admin, username, password, ano_nascimento, altura_cm, peso, genero, doenca_pre_existente):
    hashed_pw = hash_password(password)
    recovery_key = gen_recovery_key()
    hashed_chave = hash_password(recovery_key)

    query_user = """
    INSERT INTO users (
        is_admin,
        username,
        password,
        ano_nascimento,
        altura_cm,
        peso,
        genero,
        doenca_pre_existente,
        recovery_key
    ) VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s) RETURNING id;
    """

    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query_user, (
                    is_admin,
                    username,
                    hashed_pw,
                    ano_nascimento,
                    altura_cm,
                    peso,
                    genero,
                    doenca_pre_existente,
                    hashed_chave
                ))
                user_id = cur.fetchone()[0]
                conn.commit()
                print("Utilizador inserido com sucesso.")
                return recovery_key  # Devolve a chave original gerada
        except Exception as e:
            print("Erro ao inserir:", e)
        finally:
            conn.close()
    return None



# READ all
def get_all_users():
    query = "SELECT is_admin, id, username, ano_nascimento, altura_cm, peso, genero FROM users ORDER BY id;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query)
                return cur.fetchall()
        except Exception as e:
            print("Erro ao ler utilizadores:", e)
        finally:
            conn.close()
    return []

# READ by id
def get_user_by_id(user_id):
    query = "SELECT is_admin, id, username, ano_nascimento, altura_cm, peso, genero FROM users WHERE id = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (user_id,))
                return cur.fetchone()
        except Exception as e:
            print("Erro ao obter utilizador:", e)
        finally:
            conn.close()
    return None

# UPDATE
def update_user(
    user_id,
    username=None,
    ano_nascimento=None,
    altura_cm=None,
    peso=None,
    genero=None,
    doenca_pre_existente=None
):
    conn = get_connection()
    if conn:
        try:
            updates = []
            values = []

            if username is not None:
                updates.append("username = %s")
                values.append(username)
            if ano_nascimento is not None:
                updates.append("ano_nascimento = %s")
                values.append(ano_nascimento)
            if altura_cm is not None:
                updates.append("altura_cm = %s")
                values.append(altura_cm)
            if peso is not None:
                updates.append("peso = %s")
                values.append(peso)
            if genero is not None:
                updates.append("genero = %s")
                values.append(genero)
            if doenca_pre_existente is not None:
                updates.append("doenca_pre_existente = %s")
                values.append(doenca_pre_existente)
            if not updates:
                return False

            values.append(user_id)
            query = f"UPDATE users SET {', '.join(updates)} WHERE id = %s;"
            with conn.cursor() as cur:
                cur.execute(query, tuple(values))
                conn.commit()
                return True
        except Exception as e:
            print("Erro ao atualizar utilizador:", e)
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
            print("Erro ao apagar utilizador:", e)
        finally:
            conn.close()
    return False


def get_user_by_username(username):
    query = "SELECT is_admin, id, username, password FROM users WHERE username = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (username,))
                return cur.fetchone()
        except Exception as e:
            print("Erro ao buscar utilizador:", e)
        finally:
            conn.close()
    return None



def recuperar_password(username: str, recovery_key: str, nova_password: str) -> bool:
    conn = get_connection()
    if not conn:
        return False

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT id, recovery_key FROM users WHERE username = %s;", (username,))
            row = cur.fetchone()
            if not row:
                return False

            user_id, recovery_hash = row
            if not verify_password(recovery_key, recovery_hash):
                return False

            nova_hash = hash_password(nova_password)
            cur.execute("UPDATE users SET password = %s WHERE id = %s;", (nova_hash, user_id))
            conn.commit()
            return True
    except Exception as e:
        print("Erro ao recuperar password:", e)
        return False
    finally:
        conn.close()


def insert_friend(user_id: int, nome_do_amigo: str, numero_amigo: str) -> bool:
    conn = get_connection()

    try:
        with conn.cursor() as cur:
            cur.execute("SELECT COUNT(*) FROM friends WHERE user_id = %s", (user_id,))
            total_amigos = cur.fetchone()[0]

            if total_amigos >= 3:
                print("⚠️ Limite de 3 amigos atingido para este utilizador.")
                return False

            query = """
            INSERT INTO friends (user_id, nome_do_amigo, numero_amigo)
            VALUES (%s, %s, %s)
            """
            cur.execute(query, (user_id, nome_do_amigo, numero_amigo))
            conn.commit()
            return True

    except Exception as e:
        print(f"❌ Erro ao adicionar amigo: {e}")
        return False