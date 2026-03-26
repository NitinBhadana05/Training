from fastapi import FastAPI, Depends
from app.routes import user, product, signup, login

from sqlalchemy.orm import Session
from database import get_db
import models

app = FastAPI()

app.include_router(user.router)
app.include_router(product.router)
app.include_router(signup.router)
app.include_router(login.router)








