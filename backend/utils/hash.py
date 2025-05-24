from passlib.context import CryptContext

# Define o algoritmo de hashing
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

# Hashear a password original (ex: no registo)
def hash_password(password: str) -> str:
    return pwd_context.hash(password)

# Verificar password (ex: no login)
def verify_password(plain_password: str, hashed_password: str) -> bool:
    return pwd_context.verify(plain_password, hashed_password)
