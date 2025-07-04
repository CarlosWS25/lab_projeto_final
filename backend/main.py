from fastapi import FastAPI
from contextlib import asynccontextmanager
from dotenv import load_dotenv
import os
import openai

load_dotenv()  

openai.api_key = os.getenv("OPENAI_API_KEY")
if not openai.api_key:
    raise RuntimeError("OPENAI_API_KEY não definida no .env")

from database.setup import create_table_users, create_table_friends
from routes import users, auth, predict, friends

@asynccontextmanager
async def lifespan(app: FastAPI):
    create_table_users()
    create_table_friends()
    yield

app = FastAPI(lifespan=lifespan)
app.include_router(friends.router, prefix="/friends")
app.include_router(users.router, prefix="/users")
app.include_router(auth.router)
app.include_router(predict.router)
