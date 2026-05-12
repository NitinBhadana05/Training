/* eslint-disable @typescript-eslint/no-explicit-any */
import {
  NextRequest,
  NextResponse,
} from "next/server";

import jwt from "jsonwebtoken";

export function middleware(
  req: NextRequest
) {
  const token =
    req.headers
      .get("authorization")
      ?.split(" ")[1];

  if (!token) {
    return NextResponse.redirect(
      new URL(
        "/login",
        req.url
      )
    );
  }

  try {
    const decoded: any =
      jwt.verify(
        token,
        process.env
          .ACCESS_TOKEN_SECRET!
      );

    const pathname =
      req.nextUrl.pathname;

    if (
      pathname.startsWith(
        "/admin"
      ) &&
      decoded.role !==
        "ADMIN"
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
  ],
};