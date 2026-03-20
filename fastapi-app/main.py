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
