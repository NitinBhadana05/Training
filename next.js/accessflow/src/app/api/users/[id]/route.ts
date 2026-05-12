import { prisma } from "@/lib/prisma";
import { requireAdmin, requireAuth } from "@/lib/auth";
import bcrypt from "bcryptjs";
import {
  adminUpdateUserSchema,
  getFirstZodError,
} from "@/lib/validations";

interface Props {
  params: Promise<{
    id: string;
  }>;
}

export async function GET(
  _req: Request,
  { params }: Props
) {
  try {
    const { id } =
      await params;

    const auth =
      await requireAuth();
    if (!auth) {
      return Response.json(
        {
          message:
            "Unauthorized",
        },
        { status: 401 }
      );
    }

    if (
      auth.role !== "ADMIN" &&
      auth.id !== id
    ) {
      return Response.json(
        {
          message:
            "Forbidden",
        },
        { status: 403 }
      );
    }

    const user =
      await prisma.user.findUnique({
        where: {
          id,
        },

        select: {
          id: true,
          name: true,
          email: true,
          role: true,
        },
      });

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
          "Server Error",
      },
      { status: 500 }
    );
  }
}

export async function PATCH(
  req: Request,
  { params }: Props
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

    const { id } =
      await params;

    const body = await req.json();
    const parsed =
      adminUpdateUserSchema.safeParse(
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
      role,
      isVerified,
      password,
    } = parsed.data;

    const data: Record<
      string,
      unknown
    > = {
      name,
      email,
      role,
      isVerified,
    };

    if (
      typeof password ===
        "string" &&
      password.trim()
    ) {
      data.password =
        await bcrypt.hash(
          password,
          10
        );
    }

    const updatedUser =
      await prisma.user.update({
        where: { id },
        data,
        select: {
          id: true,
          name: true,
          email: true,
          role: true,
          isVerified: true,
        },
      });

    return Response.json(
      updatedUser
    );
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

export async function DELETE(
  _req: Request,
  { params }: Props
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

    const { id } =
      await params;

    await prisma.user.delete({
      where: { id },
    });

    return Response.json({
      message:
        "User deleted",
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
