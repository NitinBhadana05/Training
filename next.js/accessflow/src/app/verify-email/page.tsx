"use client";

import { useEffect } from "react";

import {
  useSearchParams,
} from "next/navigation";

export default function VerifyEmailPage() {
  const searchParams =
    useSearchParams();

  useEffect(() => {
    const verifyEmail =
      async () => {
        const token =
          searchParams.get(
            "token"
          );

        if (!token) return;

        const response =
          await fetch(
            `/api/auth/verify-email?token=${token}`
          );

        const data =
          await response.json();

        alert(
          data.message
        );
      };

    verifyEmail();
  }, [searchParams]);

  return (
    <div className="flex min-h-screen items-center justify-center">
      <h1 className="text-2xl font-bold">
        Verifying Email...
      </h1>
    </div>
  );
}