import { cookies } from "next/headers";
import { prisma } from "@/lib/prisma";
import { verifyAccessToken } from "@/lib/jwt";

export async function GET() {
  try {
    const cookieStore =
      await cookies();

    const accessToken =
      cookieStore.get(
        "accessToken"
      )?.value;

    if (!accessToken) {
      return Response.json(
        {
          message:
            "Unauthorized",
        },
        { status: 401 }
      );
    }

    const decoded =
      verifyAccessToken(
        accessToken
      );

    const user =
      await prisma.user.findUnique(
        {
          where: {
            id: decoded.id,
          },
          select: {
            id: true,
            name: true,
            email: true,
            role: true,
            isVerified: true,
          },
        }
      );

    if (!user) {
      return Response.json(
        {
          message:
            "User not found",
        },
        { status: 404 }
      );
    }

    return Response.json(user);
  } catch {
    return Response.json(
      {
        message:
          "Unauthorized",
      },
      { status: 401 }
    );
  }
}
