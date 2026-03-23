from fastapi import APIRouter

router = APIRouter(prefix="/users")

@router.get("/")
def get_users():
     return {"message": "User list"}
     
@router.post("/")
def crate_user():
     return {"message": "User created"}
