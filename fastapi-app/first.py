from fastapi import FastAPI

app = FastAPI()

@app.get("/home")
def home():
    
    return {"id": "A12S3","Status":"Complete"}
    
@app.get("/")
def index():
    return {"msg": "home"}

@app.get("/about")
def about():
    return {"msg": "about page"}

@app.post("/items")
def create_item():
    return {"message": "Item created"}

@app.put("/items/{item_id}")
def update_item(item_id: int):
    return {"message": f"Item {item_id} updated"}

@app.delete("/items/{item_id}")
def delete_item(item_id: int):
    return {"message": f"Item {item_id} deleted"}
    
#pratice Path parameters and Quarry parameters 
@app.get("/student/{id}")
def get_stsudent(id: int):
    return {"id":id}
    
@app.get("/search")
def search(name: str):
    return {"name": name}
    
@app.get("/users/{user_id}")
def get_user(user_id: int, is_active: bool):
    return({"user_id": user_id, "active": is_active})
    
@app.get("/car/{id}")  
def get_car(id: int):
    return {"id": id}

@app.get("/fillter")
def get_price(price: int):
    return {"price":price}
    
@app.get("/orders/{order_id}")
def  get_order(order_id: int, status: str):
    return {"order_id": order_id,"status": status}
    
    
#Requesting body (jason + pydantic)

from pydantic import BaseModel

class User(BaseModel):
    username: str
    password: str
  
@app.post("/login1")
def login1(user:User):
    return {"username": user.username, 
    "message": "Login successful"
    }
    
class Signin(BaseModel):
    name: str
    email: str
    age: int
   
@app.post("/signin")
def signin(user: Signin):
    return {"message": f"{user.name} is registered"} 
    
#1
@app.post("/login")
def login(user: User):
    return {"username": user.username}
    
#2    
@app.post("/user")
def user(user: Signin):
    return {"name":user.name,"age":user.age}
    
#3
class Product(BaseModel):
    name: str
    price: int
    
@app.post("/product")
def product(item: Product):
    return {
    "message": "Product created",
    "name": item.name,
    "price": item.price
}
    
#4 
@app.put("/user/{user_id}")
def update_user(user_id: int, user: Signin):
    return {
        "user_id": user_id,
        "name": user.name,
        "age": user.age
    }
    
#5

class Register(BaseModel):
     email: str
     password: str
    
@app.post("/register")
def reg(r: Register):
    return {"message": "user registered"}
 
    
