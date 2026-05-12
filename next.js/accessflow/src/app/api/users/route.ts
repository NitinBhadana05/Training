import bcrypt from "bcryptjs";
import { prisma } from "@/lib/prisma";
import { requireAdmin } from "@/lib/auth";

export async function GET() {
  try {
    const auth =
      await requireAdmin();
    if (!auth.ok) {
      return Response.json(
        {
          message:
            auth.message,
        },
        { status: auth.status }
      );
    }

    const users =
      await prisma.user.findMany({
        orderBy: {
          createdAt: "desc",
        },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          isVerified: true,
          createdAt: true,
        },
      });

    return Response.json(users);
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

export async function POST(
  req: Request
) {
  try {
    const auth =
      await requireAdmin();
    if (!auth.ok) {
      return Response.json(
        {
          message:
            auth.message,
        },
        { status: auth.status }
      );
    }

    const {
      name,
      email,
      password,
      role,
      isVerified,
    } = await req.json();

    const existingUser =
      await prisma.user.findUnique({
        where: { email },
      });

    if (existingUser) {
      return Response.json(
        {
          message:
            "Email already in use",
        },
        { status: 400 }
      );
    }

    const hashedPassword =
      await bcrypt.hash(
        password,
        10
      );

    const user =
      await prisma.user.create({
        data: {
          name,
          email,
          password:
            hashedPassword,
          role:
            role === "ADMIN"
              ? "ADMIN"
              : "USER",
          isVerified:
            Boolean(
              isVerified
            ),
        },
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          isVerified: true,
        },
      });

    return Response.json(user, {
      status: 201,
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
