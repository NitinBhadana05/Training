import { cookies } from "next/headers";
import { verifyAccessToken } from "@/lib/jwt";

export async function requireAuth() {
  const cookieStore =
    await cookies();
  const accessToken =
    cookieStore.get(
      "accessToken"
    )?.value;

  if (!accessToken) {
    return null;
  }

  try {
    return verifyAccessToken(
      accessToken
    );
  } catch {
    return null;
  }
}

export async function requireAdmin() {
  const user =
    await requireAuth();

  if (!user) {
    return {
      ok: false as const,
      status: 401,
      message:
        "Unauthorized",
    };
  }

  if (user.role !== "ADMIN") {
    return {
      ok: false as const,
      status: 403,
      message: "Forbidden",
    };
  }

  return {
    ok: true as const,
    user,
  };
}
