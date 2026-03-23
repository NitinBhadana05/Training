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
