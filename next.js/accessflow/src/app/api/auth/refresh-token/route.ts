import { cookies } from "next/headers";

import { prisma } from "@/lib/prisma";

import {
  generateAccessToken,
  verifyRefreshToken,
} from "@/lib/jwt";

export async function POST() {
  try {
    const cookieStore =
      cookies();

    const refreshToken =
      (await cookieStore).get(
        "refreshToken"
      )?.value;

    if (!refreshToken) {
      return Response.json(
        {
          message:
            "No token",
        },
        { status: 401 }
      );
    }

    const decoded =
      verifyRefreshToken(
        refreshToken
      );

    const user =
      await prisma.user.findUnique({
        where: {
          id: decoded.id,
        },
      });

    if (
      !user ||
      user.refreshToken !==
        refreshToken
    ) {
      return Response.json(
        {
          message:
            "Invalid token",
        },
        { status: 401 }
      );
    }

    const accessToken =
      generateAccessToken(
        user
      );

    const response =
      Response.json({
        message:
          "Token refreshed",
      });

    response.headers.append(
      "Set-Cookie",
      `accessToken=${accessToken}; HttpOnly; Path=/; Max-Age=900; SameSite=Lax`
    );

    return response;
  } catch {
    return Response.json(
      {
        message:
          "Server Error",
      },
      { status: 500 }
    );
  }
}
