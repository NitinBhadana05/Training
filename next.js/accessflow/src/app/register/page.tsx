"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

export default function RegisterPage() {
  const router =
    useRouter();

  const [formData, setFormData] = useState({
    name: "",
    email: "",
    password: "",
  });

  const handleSubmit = async (
    e: React.FormEvent
  ) => {
    e.preventDefault();

    const response = await fetch(
      "/api/auth/register",
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

    if (response.ok) {
      alert(
        "Registration successful. Please verify your email, then login."
      );
      router.push("/login");
      return;
    }

    alert(data.message);
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
          Register
        </h1>

        <input
          type="text"
          placeholder="Name"
          className="border p-2"
          onChange={(e) =>
            setFormData({
              ...formData,
              name: e.target.value,
            })
          }
        />

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
          Register
        </button>
      </form>
    </div>
  );
}
