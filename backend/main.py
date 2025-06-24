from fastapi import FastAPI
from contextlib import asynccontextmanager
from database.setup import create_table_users
from routes import users, auth, predict

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_table_users()
    yield
    

app = FastAPI(lifespan=lifespan)
app.include_router(users.router, prefix="/users")
app.include_router(auth.router)
app.include_router(predict.router)


