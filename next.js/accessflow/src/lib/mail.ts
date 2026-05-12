import nodemailer from "nodemailer";

const getBaseUrl = () =>
  process.env
    .NEXT_PUBLIC_BASE_URL ||
  "http://localhost:3000";

export const sendVerificationEmail =
  async (
    email: string,
    token: string
  ) => {
    const transporter =
      nodemailer.createTransport({
        service: "gmail",

        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS,
        },
      });

    const verificationLink =
      `${getBaseUrl()}/api/auth/verify-email?token=${token}`;

    await transporter.sendMail({
      from: process.env.EMAIL_USER,

      to: email,

      subject: "Verify Email",

      html: `
        <h1>Email Verification</h1>

        <a href="${verificationLink}">
          Verify Email
        </a>
      `,
    });
  };

export const sendResetPasswordEmail =
  async (
    email: string,
    token: string
  ) => {
    const transporter =
      nodemailer.createTransport({
        service: "gmail",
        auth: {
          user: process.env.EMAIL_USER,
          pass: process.env.EMAIL_PASS,
        },
      });

    const resetLink = `${getBaseUrl()}/reset-password?token=${token}`;

    await transporter.sendMail({
      from: process.env.EMAIL_USER,
      to: email,
      subject: "Reset Password",
      html: `
        <h1>Password Reset</h1>
        <a href="${resetLink}">
          Reset Password
        </a>
      `,
    });
  };
