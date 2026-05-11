"use client";

import { useForm } from "react-hook-form";
import { useRouter } from "next/navigation";

type FormData = {
  name: string;
  email: string;
  password: string;
};

export default function RegisterPage() {
  const router = useRouter();

  const {
    register,
    handleSubmit,
  } = useForm<FormData>();

  const onSubmit = async (data: FormData) => {
    const res = await fetch("/api/register", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(data),
    });

    if (res.ok) {
      router.push("/login");
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center px-4">
      <form
        onSubmit={handleSubmit(onSubmit)}
        className="flex w-full max-w-[350px] flex-col gap-4 rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-6 shadow-sm"
      >
        <h1 className="text-3xl font-bold text-zinc-950">
          Register
        </h1>

        <input
          {...register("name")}
          placeholder="Name"
          className="rounded border border-zinc-300 bg-white p-3 text-zinc-900 placeholder:text-zinc-500"
        />

        <input
          {...register("email")}
          placeholder="Email"
          className="rounded border border-zinc-300 bg-white p-3 text-zinc-900 placeholder:text-zinc-500"
        />

        <input
          {...register("password")}
          type="password"
          placeholder="Password"
          className="rounded border border-zinc-300 bg-white p-3 text-zinc-900 placeholder:text-zinc-500"
        />

        <button
          className="rounded bg-blue-700 p-3 text-white transition-colors hover:bg-blue-800 active:bg-blue-900"
        >
          Create Account
        </button>
      </form>
    </main>
  );
}
