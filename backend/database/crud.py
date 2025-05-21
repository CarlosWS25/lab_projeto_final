from .connection import get_connection

# CREATE
def insert_user(name, email, password):
    query = "INSERT INTO users (name, email, password) VALUES (%s, %s, %s);"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (name, email, password))
                conn.commit()
                print("✅ Utilizador inserido.")
        except Exception as e:
            print("❌ Erro ao inserir:", e)
        finally:
            conn.close()

# READ
def get_all_users():
    query = "SELECT id, name, email FROM users ORDER BY id;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query)
                users = cur.fetchall()
                return users
        except Exception as e:
            print("❌ Erro ao ler utilizadores:", e)
        finally:
            conn.close()
    return []

def get_user_by_id(user_id):
    query = "SELECT id, name, email FROM users WHERE id = %s;"
    conn = get_connection()
    if conn:
        try:
            with conn.cursor() as cur:
                cur.execute(query, (user_id,))
                user = cur.fetchone()
                return user
        except Exception as e:
            print("❌ Erro ao obter utilizador:", e)
        finally:
            conn.close()
    return None

# UPDATE
def update_user(user_id, name=None, email=None, password=None):
    conn = get_connection()
    if conn:
        try:
            updates = []
            values = []

            if name:
                updates.append("name = %s")
                values.append(name)
            if email:
                updates.append("email = %s")
                values.append(email)
            if password:
                updates.append("password = %s")
                values.append(password)

            if not updates:
                return False  # Nada para atualizar

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
