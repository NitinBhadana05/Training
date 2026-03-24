from fastapi import FastAPI, Depends
from app.routes import user,product

from sqlalchemy.orm import Session
from database import get_db
import models

app = FastAPI()

app.include_router(user.router)
app.include_router(product.router)





@app.post("/users")
def create_user(name: str, age: int, db: Session = Depends(get_db)):
    user = models.User(name=name, age=age)

    db.add(user)
    db.commit()
    db.refresh(user)

    return user
