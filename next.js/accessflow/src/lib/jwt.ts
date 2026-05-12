import jwt from "jsonwebtoken";

type UserTokenPayload = {
  id: string;
  role: "USER" | "ADMIN";
};

export const generateAccessToken = (
  user: UserTokenPayload
) => {
  return jwt.sign(
    {
      id: user.id,
      role: user.role,
    },

    process.env.ACCESS_TOKEN_SECRET!,

    {
      expiresIn: "15m",
    }
  );
};

export const generateRefreshToken = (
  user: Pick<
    UserTokenPayload,
    "id"
  >
) => {
  return jwt.sign(
    {
      id: user.id,
    },

    process.env.REFRESH_TOKEN_SECRET!,

    {
      expiresIn: "7d",
    }
  );
};

export const verifyAccessToken = (
  token: string
) =>
  jwt.verify(
    token,
    process.env
      .ACCESS_TOKEN_SECRET!
  ) as UserTokenPayload;

export const verifyRefreshToken = (
  token: string
) =>
  jwt.verify(
    token,
    process.env
      .REFRESH_TOKEN_SECRET!
  ) as {
    id: string;
  };
