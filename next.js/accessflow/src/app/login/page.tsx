"use client";

import { useState } from "react";

import { useRouter } from "next/navigation";
import Link from "next/link";

export default function LoginPage() {
  const router =
    useRouter();

  const [formData, setFormData] =
    useState({
      email: "",
      password: "",
    });

  const handleSubmit = async (
    e: React.FormEvent
  ) => {
    e.preventDefault();

    const response = await fetch(
      "/api/auth/login",
      {
        method: "POST",

        headers: {
          "Content-Type":
            "application/json",
        },

        body: JSON.stringify(
          formData
        ),
      }
    );

    const data =
      await response.json();

    if (
      response.ok
    ) {
      router.push(
        "/dashboard"
      );
    } else {
      alert(data.message);
    }
  };

  return (
    <div className="flex min-h-screen items-center justify-center">
      <form
        onSubmit={
          handleSubmit
        }
        className="flex w-[400px] flex-col gap-4 rounded border p-6"
      >
        <h1 className="text-2xl font-bold">
          Login
        </h1>

        <input
          type="email"
          placeholder="Email"
          className="border p-2"
          onChange={(e) =>
            setFormData({
              ...formData,
              email:
                e.target.value,
            })
          }
        />

        <input
          type="password"
          placeholder="Password"
          className="border p-2"
          onChange={(e) =>
            setFormData({
              ...formData,
              password:
                e.target.value,
            })
          }
        />

        <button className="bg-black p-2 text-white">
          Login
        </button>

        <Link
          href="/forgot-password"
          className="text-sm text-blue-600"
        >
          Forgot password?
        </Link>

        <Link
          href="/register"
          className="border p-2 text-center"
        >
          Register
        </Link>
      </form>
    </div>
  );
}
