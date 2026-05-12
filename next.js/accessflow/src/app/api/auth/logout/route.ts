import { cookies } from "next/headers";
import { prisma } from "@/lib/prisma";
import { verifyAccessToken } from "@/lib/jwt";

export async function POST() {
  try {
    const cookieStore =
      await cookies();
    const accessToken =
      cookieStore.get(
        "accessToken"
      )?.value;

    if (accessToken) {
      try {
        const decoded =
          verifyAccessToken(
            accessToken
          );
        await prisma.user.update({
          where: {
            id: decoded.id,
          },
          data: {
            refreshToken: null,
          },
        });
      } catch {
        // Ignore token parsing error on logout.
      }
    }

    const response =
      Response.json({
        message:
          "Logged out successfully",
      });

    response.headers.append(
      "Set-Cookie",
      "accessToken=; HttpOnly; Path=/; Max-Age=0; SameSite=Lax"
    );
    response.headers.append(
      "Set-Cookie",
      "refreshToken=; HttpOnly; Path=/; Max-Age=0; SameSite=Lax"
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
