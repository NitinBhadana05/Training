import { z } from "zod";

export const registerSchema =
  z.object({
    name: z
      .string()
      .trim()
      .min(2, "Name must be at least 2 characters"),
    email: z
      .email(
        "Enter a valid email"
      )
      .transform((value) =>
        value.toLowerCase()
      ),
    password: z
      .string()
      .min(
        8,
        "Password must be at least 8 characters"
      ),
  });

export const loginSchema =
  z.object({
    email: z
      .email(
        "Enter a valid email"
      )
      .transform((value) =>
        value.toLowerCase()
      ),
    password: z
      .string()
      .min(1, "Password is required"),
  });

export const forgotPasswordSchema =
  z.object({
    email: z
      .email(
        "Enter a valid email"
      )
      .transform((value) =>
        value.toLowerCase()
      ),
  });

export const resetPasswordSchema =
  z.object({
    token: z
      .string()
      .min(1, "Token is required"),
    password: z
      .string()
      .min(
        8,
        "Password must be at least 8 characters"
      ),
  });

export const adminCreateUserSchema =
  z.object({
    name: z
      .string()
      .trim()
      .min(2, "Name must be at least 2 characters"),
    email: z
      .email(
        "Enter a valid email"
      )
      .transform((value) =>
        value.toLowerCase()
      ),
    password: z
      .string()
      .min(
        8,
        "Password must be at least 8 characters"
      ),
    role: z.enum([
      "USER",
      "ADMIN",
    ]),
    isVerified: z.boolean(),
  });

export const adminUpdateUserSchema =
  z.object({
    name: z
      .string()
      .trim()
      .min(2, "Name must be at least 2 characters"),
    email: z
      .email(
        "Enter a valid email"
      )
      .transform((value) =>
        value.toLowerCase()
      ),
    password: z
      .string()
      .min(
        8,
        "Password must be at least 8 characters"
      )
      .optional()
      .or(z.literal("")),
    role: z.enum([
      "USER",
      "ADMIN",
    ]),
    isVerified: z.boolean(),
  });

export const getFirstZodError = (
  error: z.ZodError
) =>
  error.issues[0]?.message ??
  "Invalid input";
