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

@app.post("/products")
def create_product(name: str, price: int, db: Session = Depends(get_db)):
    product = models.Product(name=name, price=price)

    db.add(product)
    db.commit()
    db.refresh(product)

    return product

@app.get("/products/{id}")
def get_product(id: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:
        return {"error": "Product not found"}

    return product

@app.put("/products/{id}")
def update_product(id: int, name: str, price: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:
        return {"error": "Product not found"}

    product.name = name
    product.price = price

    db.commit()

    return product

@app.delete("/products/{id}")
def delete_product(id: int, db: Session = Depends(get_db)):    
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:        
        return {"error": "Product not found"}

    db.delete(product)
    db.commit()

    return {"message": "Product deleted"}   
