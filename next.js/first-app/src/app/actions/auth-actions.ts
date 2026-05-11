"use server"

import bcrypt from "bcrypt"
import jwt from "jsonwebtoken"

import { cookies } from "next/headers"
import { redirect } from "next/navigation"

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

    if (!process.env.JWT_SECRET) {
      return {
        success: "",
        error: "JWT_SECRET is not configured",
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
      secure: process.env.NODE_ENV === "production",
      path: "/",
      maxAge: 60 * 60 * 24 * 7,
    })

    redirect("/dashboard")

  } catch (error: any) {
    console.error(error)

    return {
      success: "",
      error: error.message,
    }
  }
}

export async function forgotPassword(
  prevState: any,
  formData: FormData
) {

  try {
    const email =
      formData.get("email") as string

    const user =
      await prisma.user.findUnique({
        where: {
          email,
        },
      })

    if (!user) {
      return {
        success: "",
        error: "User not found",
      }
    }

    if (!process.env.JWT_SECRET) {
      return {
        success: "",
        error: "JWT_SECRET is not configured",
      }
    }

    const resetToken = jwt.sign(
      {
        userId: user.id,
        intent: "password-reset",
      },
      process.env.JWT_SECRET,
      {
        expiresIn: "15m",
      }
    )

    console.log(
      `Reset Link:
http://localhost:3000/reset-password/${resetToken}`
    )

    return {
      success:
        "Reset link generated in terminal",
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

export async function resetPassword(
  prevState: {
    success: string
    error: string
  },
  formData: FormData
) {
  try {
    const token = formData.get("token") as string
    const password = formData.get("password") as string

    if (!token || !password) {
      return {
        success: "",
        error: "Token and password are required",
      }
    }

    if (!process.env.JWT_SECRET) {
      return {
        success: "",
        error: "JWT_SECRET is not configured",
      }
    }

    const decoded = jwt.verify(token, process.env.JWT_SECRET) as {
      userId?: string
      intent?: string
    }

    if (
      decoded.intent !== "password-reset" ||
      !decoded.userId
    ) {
      return {
        success: "",
        error: "Invalid reset token",
      }
    }

    const hashedPassword =
      await bcrypt.hash(password, 10)

    await prisma.user.update({
      where: {
        id: decoded.userId,
      },
      data: {
        password: hashedPassword,
      },
    })

    return {
      success: "Password reset successfully",
      error: "",
    }
  } catch (error: any) {
    console.error(error)

    return {
      success: "",
      error: error.message ?? "Invalid or expired token",
    }
  }
}
