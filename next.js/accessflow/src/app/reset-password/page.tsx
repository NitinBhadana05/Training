"use client";

import { useState } from "react";
import {
  useRouter,
  useSearchParams,
} from "next/navigation";
import { resetPasswordSchema } from "@/lib/validations";

export default function ResetPasswordPage() {
  const [password, setPassword] =
    useState("");
  const searchParams =
    useSearchParams();
  const router =
    useRouter();
  const [error, setError] =
    useState("");

  const handleSubmit = async (
    e: React.FormEvent
  ) => {
    e.preventDefault();
    setError("");

    const token =
      searchParams.get("token");

    if (!token) {
      setError("Missing token");
      return;
    }

    const parsed =
      resetPasswordSchema.safeParse(
        {
          token,
          password,
        }
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
      "/api/auth/reset-password",
      {
        method: "POST",
        headers: {
          "Content-Type":
            "application/json",
        },
        body: JSON.stringify({
          token:
            parsed.data.token,
          password:
            parsed.data.password,
        }),
      }
    );

    const data =
      await response.json();
    alert(data.message);

    if (response.ok) {
      router.push("/login");
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center">
      <form
        onSubmit={handleSubmit}
        className="flex w-[400px] flex-col gap-4 rounded border p-6"
      >
        <h1 className="text-2xl font-bold">
          Reset Password
        </h1>
        {error ? (
          <p className="text-sm text-red-600">
            {error}
          </p>
        ) : null}

        <input
          type="password"
          placeholder="New Password"
          className="border p-2"
          value={password}
          onChange={(e) =>
            setPassword(
              e.target.value
            )
          }
          required
        />

        <button className="bg-black p-2 text-white">
          Reset Password
        </button>
      </form>
    </div>
  );
}
