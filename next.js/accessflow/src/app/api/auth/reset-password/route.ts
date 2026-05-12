import bcrypt from "bcryptjs";
import { prisma } from "@/lib/prisma";
import {
  getFirstZodError,
  resetPasswordSchema,
} from "@/lib/validations";

export async function POST(
  req: Request
) {
  try {
    const body = await req.json();
    const parsed =
      resetPasswordSchema.safeParse(
        body
      );
    if (!parsed.success) {
      return Response.json(
        {
          message:
            getFirstZodError(
              parsed.error
            ),
        },
        { status: 400 }
      );
    }

    const {
      token,
      password,
    } = parsed.data;

    const user =
      await prisma.user.findFirst({
        where: {
          resetPasswordToken:
            token,
        },
      });

    if (
      !user ||
      !user.resetPasswordTokenExpiry ||
      user.resetPasswordTokenExpiry <
        new Date()
    ) {
      return Response.json(
        {
          message:
            "Invalid or expired token",
        },
        { status: 400 }
      );
    }

    const hashedPassword =
      await bcrypt.hash(
        password,
        10
      );

    await prisma.user.update({
      where: { id: user.id },
      data: {
        password:
          hashedPassword,
        resetPasswordToken:
          null,
        resetPasswordTokenExpiry:
          null,
      },
    });

    return Response.json({
      message:
        "Password reset successful",
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
