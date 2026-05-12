import crypto from "crypto";
import { prisma } from "@/lib/prisma";
import { sendResetPasswordEmail } from "@/lib/mail";

export async function POST(
  req: Request
) {
  try {
    const { email } =
      await req.json();

    const user =
      await prisma.user.findUnique({
        where: { email },
      });

    if (!user) {
      return Response.json({
        message:
          "If this email exists, a reset link has been sent.",
      });
    }

    const resetPasswordToken =
      crypto
        .randomBytes(32)
        .toString("hex");

    await prisma.user.update({
      where: { id: user.id },
      data: {
        resetPasswordToken,
        resetPasswordTokenExpiry:
          new Date(
            Date.now() +
              1000 *
                60 *
                30
          ),
      },
    });

    void sendResetPasswordEmail(
      email,
      resetPasswordToken
    ).catch(() => {
      // Keep response fast even if email fails.
    });

    return Response.json({
      message:
        "If this email exists, a reset link has been sent.",
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
