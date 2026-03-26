from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
import models

router = APIRouter(prefix="/products")


@router.post("/")
def create_product(name: str, price: int, db: Session = Depends(get_db)):
    product = models.Product(name=name, price=price)

    db.add(product)
    db.commit()
    db.refresh(product)

    return product

@router.get("/{id}")
def get_product(id: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:
        return {"error": "Product not found"}

    return product

@router.put("/{id}")
def update_product(id: int, name: str, price: int, db: Session = Depends(get_db)):
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:
        return {"error": "Product not found"}

    product.name = name
    product.price = price

    db.commit()

    return product

@router.delete("/{id}")
def delete_product(id: int, db: Session = Depends(get_db)):    
    product = db.query(models.Product).filter(models.Product.id == id).first()

    if not product:        
        return {"error": "Product not found"}

    db.delete(product)
    db.commit()

    return {"message": "Product deleted"}   