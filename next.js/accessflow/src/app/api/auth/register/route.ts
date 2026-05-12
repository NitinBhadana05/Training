import { prisma } from "@/lib/prisma";

import bcrypt from "bcryptjs";

import crypto from "crypto";

import { sendVerificationEmail } from "@/lib/mail";
import {
  getFirstZodError,
  registerSchema,
} from "@/lib/validations";

export async function POST(req: Request) {
  try {
    const body = await req.json();
    const parsed =
      registerSchema.safeParse(
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
      name,
      email,
      password,
    } = parsed.data;

    const existingUser =
      await prisma.user.findUnique({
        where: { email },
      });

    if (existingUser) {
      return Response.json(
        {
          message:
            "User already exists",
        },
        { status: 400 }
      );
    }

    const hashedPassword =
      await bcrypt.hash(
        password,
        10
      );

    const verificationToken =
      crypto
        .randomBytes(32)
        .toString("hex");

    await prisma.user.create({
      data: {
        name,
        email,
        password:
          hashedPassword,

        verificationToken,

        verificationTokenExpiry:
          new Date(
            Date.now() +
              1000 *
                60 *
                60
          ),
      },
    });

    void sendVerificationEmail(
      email,
      verificationToken
    ).catch(() => {
      // Keep response fast even if email fails.
    });

    return Response.json({
      message:
        "User registered",
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
