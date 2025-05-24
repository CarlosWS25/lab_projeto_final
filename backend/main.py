from fastapi import FastAPI
from contextlib import asynccontextmanager
from database.setup import create_table
from routes import users, auth

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_table()
    yield
    

app = FastAPI(lifespan=lifespan)

app.include_router(users.router, prefix="/users")
app.include_router(auth.router)
