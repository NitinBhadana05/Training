import { cookies } from "next/headers";
import { prisma } from "@/lib/prisma";
import { verifyAccessToken } from "@/lib/jwt";
import { notFound } from "next/navigation";

interface Props {
  params: Promise<{
    id: string;
  }>;
}

export default async function UserPage({
  params,
}: Props) {
  const { id } =
    await params;

  const accessToken =
    (await cookies()).get(
      "accessToken"
    )?.value;

  if (!accessToken) {
    notFound();
  }

  let decoded: ReturnType<
    typeof verifyAccessToken
  >;
  try {
    decoded =
      verifyAccessToken(
        accessToken
      );
  } catch {
    notFound();
  }

  if (
    decoded.role !== "ADMIN" &&
    decoded.id !== id
  ) {
    notFound();
  }

  const user =
    await prisma.user.findUnique({
      where: { id },
      select: {
        id: true,
        name: true,
        email: true,
        role: true,
      },
    });

  if (!user) {
    notFound();
  }

  return (
    <div>
      <h1>
        {user.name}
      </h1>

      <p>
        {user.email}
      </p>

      <p>
        {user.role}
      </p>
    </div>
  );
}
