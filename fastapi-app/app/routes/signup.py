from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
import models
from app.routes.working_functions import hash_password


router = APIRouter(prefix="/signup")

@router.post("/")
def signup(name: str, email: str, password: str, db: Session = Depends(get_db)):
 hashed_password = hash_password(password)
 new_user = models.Registor(name=name, email=email, password=hashed_password)

 db.add(new_user)
 db.commit()
 db.refresh(new_user)

 return {"message": "User created"}


@router.get("/{id}")
def get_users(id: int, db: Session = Depends(get_db)):
    users = db.query(models.Registor).filter(models.Registor.id == id).first()

    if not users:
        return {"error": "User not found"}
    
    return users