import os
from fastapi import APIRouter, Request, Form
from fastapi.templating import Jinja2Templates

from app.services.number_Logic import (
    get_primes,
    get_factorial,
    get_fibonacci,
    reverse_number,
    is_armstrong,
    is_strong,
    check_even_odd
)

router = APIRouter()

# template path
BASE_DIR = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
templates = Jinja2Templates(directory=os.path.join(BASE_DIR, "templates"))


# ===== HOME =====
@router.get("/")
async def home(request: Request):
    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": ""}
    )


# ===== PRIME =====
@router.post("/prime")
async def prime(request: Request, start: int = Form(...), end: int = Form(...)):

    
   
    if start > end:
        result = "Start cannot be greater than End"
    elif start < 0 or end < 0:
        result = "Negative values not allowed"
    elif start == end:
        result = "Start and End cannot be same"
    else:
        primes = get_primes(start, end)
        result = "Prime numbers between " + str(start) + " and " + str(end) + ": " + ", ".join(map(str, primes)) if primes else "No primes found"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== FACTORIAL =====
@router.post("/factorial")
async def factorial(request: Request, value: int = Form(...)):

    if value < 0:
        result = "Negative values not allowed"
    else:
        res = get_factorial(value)
        result = f"Factorial of {value}: {res}"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== FIBONACCI =====
@router.post("/fibonacci")
async def fibonacci(request: Request, value: int = Form(...)):

    if value < 0:
        result = "Negative values not allowed"
    else:
        series = get_fibonacci(value)
        result = "Fibonacci Series (" + str(value) + " terms): " + ", ".join(map(str, series))

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== REVERSE =====
@router.post("/reverse")
async def reverse(request: Request, value: int = Form(...)):

    rev = reverse_number(value)
    result = f"Reverse of {value} : {rev}"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== ARMSTRONG =====
@router.post("/armstrong")
async def armstrong(request: Request, value: int = Form(...)):

    result = f"{value} is {is_armstrong(value) } Number"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== STRONG =====
@router.post("/strong")
async def strong(request: Request, value: int = Form(...)):

    result = f"{value} is {is_strong(value) } Number"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )


# ===== ODD / EVEN =====
@router.post("/evenodd")
async def evenodd(request: Request, value: int = Form(...)):

    result = f"{value} is {check_even_odd(value) } Number"

    return templates.TemplateResponse(
        request,
        "index.html",
        {"result": result}
    )