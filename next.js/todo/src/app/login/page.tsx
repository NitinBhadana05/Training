"use client";

import Link from "next/link";
import { useForm } from "react-hook-form";
import { signIn } from "next-auth/react";
import { useRouter } from "next/navigation";

type FormData = {
  email: string;
  password: string;
};

export default function LoginPage() {
  const router = useRouter();

  const {
    register,
    handleSubmit,
  } = useForm<FormData>();

  const onSubmit = async (data: FormData) => {
    const res = await signIn("credentials", {
      ...data,
      redirect: false,
    });

    if (res?.ok) {
      router.push("/dashboard");
    }
  };

  return (
    <main className="flex min-h-screen items-center justify-center px-4">
      <form
        onSubmit={handleSubmit(onSubmit)}
        className="flex w-full max-w-[350px] flex-col gap-4 rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-6 shadow-sm"
      >
        <h1 className="text-3xl font-bold text-zinc-950">
          Login
        </h1>

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
          Login
        </button>

        <Link
          href="/register"
          className="rounded border border-zinc-300 bg-white p-3 text-center text-sm font-medium text-zinc-700 transition-colors hover:bg-zinc-100"
        >
          Sign Up
        </Link>
      </form>
    </main>
  );
}
