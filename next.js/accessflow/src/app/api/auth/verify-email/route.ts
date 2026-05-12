import { prisma } from "@/lib/prisma";

export async function GET(
  req: Request
) {
  try {
    const { searchParams } =
      new URL(req.url);

    const token =
      searchParams.get("token");

    const user =
      await prisma.user.findFirst({
        where: {
          verificationToken:
            token!,
        },
      });

    if (
      !user ||
      !user.verificationTokenExpiry ||
      user.verificationTokenExpiry <
        new Date()
    ) {
      return Response.json(
        {
          message:
            "Invalid token",
        },
        { status: 400 }
      );
    }

    await prisma.user.update({
      where: {
        id: user.id,
      },

      data: {
        isVerified: true,

        verificationToken:
          null,
      },
    });

    return Response.json({
      message:
        "Email verified",
    });
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
