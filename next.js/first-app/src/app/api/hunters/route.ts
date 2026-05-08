import {prisma}  from "@/lib/prisma"
import { NextResponse } from "next/server"

export async function GET() {
  const hunters = await prisma.hunters.findMany()

  return NextResponse.json(hunters)
}
export async function POST(request: Request) {
  const body = await request.json()

  const hunter = await prisma.hunters.create({
    data: {
      alias: body.alias,
      rank: body.rank,
      region: "Unknown",
      created_at: new Date(),
      updated_at: new Date(),
    },
  })

  return NextResponse.json(hunter)
}