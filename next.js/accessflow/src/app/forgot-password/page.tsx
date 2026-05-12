"use client";

import { useState } from "react";
import { forgotPasswordSchema } from "@/lib/validations";

export default function ForgotPasswordPage() {
  const [email, setEmail] =
    useState("");
  const [error, setError] =
    useState("");

  const handleSubmit = async (
    e: React.FormEvent
  ) => {
    e.preventDefault();
    setError("");

    const parsed =
      forgotPasswordSchema.safeParse(
        { email }
      );
    if (!parsed.success) {
      setError(
        parsed.error.issues[0]
          ?.message ??
          "Invalid input"
      );
      return;
    }

    const response = await fetch(
      "/api/auth/forgot-password",
      {
        method: "POST",
        headers: {
          "Content-Type":
            "application/json",
        },
        body: JSON.stringify({
          email:
            parsed.data.email,
        }),
      }
    );

    const data =
      await response.json();

    alert(data.message);
  };

  return (
    <div className="flex min-h-screen items-center justify-center">
      <form
        onSubmit={handleSubmit}
        className="flex w-[400px] flex-col gap-4 rounded border p-6"
      >
        <h1 className="text-2xl font-bold">
          Forgot Password
        </h1>
        {error ? (
          <p className="text-sm text-red-600">
            {error}
          </p>
        ) : null}

        <input
          type="email"
          placeholder="Email"
          className="border p-2"
          value={email}
          onChange={(e) =>
            setEmail(
              e.target.value
            )
          }
          required
        />

        <button className="bg-black p-2 text-white">
          Send Reset Link
        </button>
      </form>
    </div>
  );
}
