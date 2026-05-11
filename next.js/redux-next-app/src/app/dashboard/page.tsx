/* eslint-disable @typescript-eslint/no-explicit-any */
"use client";

import { useEffect }
from "react";

import { useRouter }
from "next/navigation";

import { useSelector }
from "react-redux";

import type { RootState }
from "@/redux/store";

export default function DashboardPage() {

  const router = useRouter();

  const user = useSelector(
    (state: RootState) =>
      (state as any).auth?.user
  );

  useEffect(() => {

    if (!user) {

      router.push("/login");

    }

  }, [user, router]);

  if (!user) {

    return <p>Redirecting...</p>;

  }

  return (
    <div>

      <h1>Dashboard</h1>

      <p>Welcome {user.name}</p>

    </div>
  );
}