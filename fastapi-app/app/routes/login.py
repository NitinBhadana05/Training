from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from app.routes.working_functions import verify_password,create_access_token
import models


router = APIRouter(prefix="/login")


@router.post("/")
def login(email: str, password: str, db: Session = Depends(get_db)):
  user = db.query(models.Registor).filter(models.Registor.email == email).first()

  if not user:
    return {"error": "User not found"}

  if not verify_password(password, user.password):
    return {"error": "Invalid password"}
  token = create_access_token(data={"sub": user.email})
  return {"access_token": token}
