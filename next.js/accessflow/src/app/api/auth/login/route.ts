import bcrypt from "bcryptjs";

import { prisma } from "@/lib/prisma";

import {
  generateAccessToken,
  generateRefreshToken,
} from "@/lib/jwt";

export async function POST(
  req: Request
) {
  try {
    const {
      email,
      password,
    } = await req.json();

    const user =
      await prisma.user.findUnique({
        where: { email },
      });

    if (!user) {
      return Response.json(
        {
          message:
            "Invalid credentials",
        },
        { status: 400 }
      );
    }

    const isPasswordCorrect =
      await bcrypt.compare(
        password,
        user.password
      );

    if (
      !isPasswordCorrect
    ) {
      return Response.json(
        {
          message:
            "Invalid credentials",
        },
        { status: 400 }
      );
    }

    if (
      !user.isVerified
    ) {
      return Response.json(
        {
          message:
            "Verify email first",
        },
        { status: 401 }
      );
    }

    const accessToken =
      generateAccessToken(
        user
      );

    const refreshToken =
      generateRefreshToken(
        user
      );

    await prisma.user.update({
      where: {
        id: user.id,
      },

      data: {
        refreshToken,
      },
    });

    const response =
      Response.json({
        message:
          "Login successful",
      });

    response.headers.append(
      "Set-Cookie",
      `accessToken=${accessToken}; HttpOnly; Path=/; Max-Age=900; SameSite=Lax`
    );

    response.headers.append(
      "Set-Cookie",
      `refreshToken=${refreshToken}; HttpOnly; Path=/; Max-Age=604800; SameSite=Lax`
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
