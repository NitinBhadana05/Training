"use client";

import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

type Me = {
  id: string;
  name: string;
  email: string;
  role: "USER" | "ADMIN";
  isVerified: boolean;
};

export default function DashboardPage() {
  const router =
    useRouter();
  const [me, setMe] =
    useState<Me | null>(null);

  useEffect(() => {
    const loadMe = async () => {
      const response =
        await fetch(
          "/api/auth/me",
          {
            cache: "no-store",
          }
        );
      if (!response.ok) return;
      const data =
        await response.json();
      setMe(data);
    };

    void loadMe();
  }, []);

  const handleLogout = async () => {
    const response = await fetch(
      "/api/auth/logout",
      {
        method: "POST",
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
    <div className="p-10">
      <h1 className="text-3xl font-bold">
        Dashboard
      </h1>

      <p>
        Protected User
        Dashboard
      </p>

      <p className="mt-2">
        Role:{" "}
        {me?.role ??
          "loading..."}
      </p>

      {me?.role === "ADMIN" ? (
        <button
          onClick={() =>
            router.push(
              "/admin"
            )
          }
          className="mt-4 border px-4 py-2"
        >
          Open Admin Panel
        </button>
      ) : null}

      <button
        onClick={
          handleLogout
        }
        className="mt-6 bg-black px-4 py-2 text-white"
      >
        Logout
      </button>
    </div>
  );
}
