from fastapi import APIRouter

router = APIRouter(prefix="/products")
@router.get("/s")
def get_products():
    return {"message": "Product list"}
