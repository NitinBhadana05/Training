from fastapi import FastAPI
from pydantic import BaseModel
from typing import Optional


app = FastAPI()

#1. all fields reequired
class Users(BaseModel):
    name: str
    age: int
  
@app.post("/user")
def create_user(user: Users):
    return {"name": user.name, "age": user.age}
    
#2. some fields optional
class Optional_User(BaseModel):
     name: str
     age: Optional[int] = None
     
@app.post("/optional")
def optional_user_create(o: Optional_User):
     return {"name": o.name, "age": o.age}
 
#3 default filds
class Product(BaseModel):
     product: str
     price: int = 500
   
@app.post("/default")
def defalut_fields(d: Product):
     return {"produc": d.product, "price": d.price}
     
     
#4. Registor table
class Registor(BaseModel):
     email: str
     password: str
     phone: Optional[int] = None
    
@app.post("/registor")
def reg(r: Registor):
     return {"message": "user registor" }
     
#5 profile post
class Profile(BaseModel):
     name: str
     age: Optional[int] = None
     countary: str = 'India'	
     
@app.post("/profile")
def profile(p: Profile):
    return {"message": "profile created"}
