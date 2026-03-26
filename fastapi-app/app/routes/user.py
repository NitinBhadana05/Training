from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
import models


router = APIRouter(prefix="/users")
  

@router.post("/users")
def create_user(name: str, age: int, db: Session = Depends(get_db)):
    user = models.User(name=name, age=age)

    db.add(user)
    db.commit()
    db.refresh(user)

    return user

@router.get("/{id}")
def get_user(id: int, db: Session = Depends(get_db)):
    user = db.query(models.User).filter(models.User.id == id).first()

    if not user:
        return {"error": "Product not found"}

    return user