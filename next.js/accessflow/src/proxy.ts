import {
  NextRequest,
  NextResponse,
} from "next/server";
import { verifyAccessToken } from "@/lib/jwt";

export function proxy(
  req: NextRequest
) {
  const accessToken =
    req.cookies.get(
      "accessToken"
    )?.value;

  if (!accessToken) {
    return NextResponse.redirect(
      new URL(
        "/login",
        req.url
      )
    );
  }

  try {
    const decoded =
      verifyAccessToken(
        accessToken
      );

    if (
      req.nextUrl.pathname.startsWith(
        "/admin"
      ) &&
      decoded.role !== "ADMIN"
    ) {
      return NextResponse.redirect(
        new URL(
          "/dashboard",
          req.url
        )
      );
    }

    return NextResponse.next();
  } catch {
    return NextResponse.redirect(
      new URL(
        "/login",
        req.url
      )
    );
  }
}

export const config = {
  matcher: [
    "/dashboard/:path*",
    "/admin/:path*",
    "/user/:path*",
  ],
};
