import NextAuth from "next-auth"
import GitHub from "next-auth/providers/github"

const providers = []

if (
  process.env.GITHUB_ID &&
  process.env.GITHUB_SECRET
) {
  providers.push(
    GitHub({
      clientId: process.env.GITHUB_ID,
      clientSecret: process.env.GITHUB_SECRET,
    })
  )
}

const handler = NextAuth({
  providers,
})

export { handler as GET, handler as POST }
