from fastapi import FastAPI
from contextlib import asynccontextmanager
from database.setup import create_table_users, create_table_saude
from routes import users, auth
from routes.saude import router as saude_router

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_table_users()
    create_table_saude()
    yield
    

app = FastAPI(lifespan=lifespan)

app.include_router(users.router, prefix="/users")
app.include_router(auth.router)
app.include_router(saude_router)

