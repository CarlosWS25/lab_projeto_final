from fastapi import FastAPI
from routes import users
from database.setup import create_table

app = FastAPI()

# Criar tabela ao iniciar
create_table()

# Incluir rotas
app.include_router(users.router, prefix="/users", tags=["Users"])

@app.get("/")
def root():
    return {"msg": "API DoseWise ativa"}
