"use server"


import bcrypt from "bcrypt"
import jwt from "jsonwebtoken"

import { cookies } from "next/headers"



import {prisma} from "@/lib/prisma"


export async function signup(
  prevState: {
    success: string
    error: string
  },
  formData: FormData
) {
  try {
    const name =
      formData.get("name") as string

    const email =
      formData.get("email") as string

    const password =
      formData.get("password") as string

    if (!name || !email || !password) {
      return {
        success: "",
        error: "All fields required",
      }
    }

    const existingUser =
      await prisma.user.findUnique({
        where: {
          email,
        },
      })

    if (existingUser) {
      return {
        success: "",
        error: "User already exists",
      }
    }

    const hashedPassword =
      await bcrypt.hash(password, 10)

    await prisma.user.create({
      data: {
        name,
        email,
        password: hashedPassword,
      },
    })

    return {
      success: "Account created",
      error: "",
    }

  } catch (error: any) {
    console.error(error)

    return {
      success: "",
      error: error.message,
    }
  }
}

export async function login(
  prevState: {
    success: string
    error: string
  },
  formData: FormData
) {
  try {
    const email =
      formData.get("email") as string

    const password =
      formData.get("password") as string

    if (!email || !password) {
      return {
        success: "",
        error: "All fields required",
      }
    }

    const user =
      await prisma.user.findUnique({
        where: {
          email,
        },
      })

    if (!user || !user.password) {
      return {
        success: "",
        error: "Invalid credentials",
      }
    }

    const isValid =
      await bcrypt.compare(
        password,
        user.password
      )

    if (!isValid) {
      return {
        success: "",
        error: "Invalid credentials",
      }
    }

    const token = jwt.sign(
      {
        userId: user.id,
        role: user.role,
      },
      process.env.JWT_SECRET!,
      {
        expiresIn: "7d",
      }
    )

    const cookieStore = await cookies()

    cookieStore.set("token", token, {
      httpOnly: true,
      secure: false,
      path: "/",
      maxAge: 60 * 60 * 24 * 7,
    })

    return {
      success: "Login successful",
      error: "",
    }

  } catch (error: any) {
    console.error(error)

    return {
      success: "",
      error: error.message,
    }
  }
}