import {prisma}  from "@/lib/prisma"
import { NextResponse } from 'next/server'


export async function GET(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params

  const hunter = await prisma.hunters.findUnique({
    where: {
      id: BigInt(id),
    },
  })

  return NextResponse.json(hunter)
}

export async function PATCH(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  try {
    const { id } = await params 
    const body = await request.json()

    const updatedHunter = await prisma.hunters.update({
      where: { 
        id: BigInt(id.trim()) 
      },
      data: {
        alias: body.alias,
        rank: body.rank,
        region: body.region,
        updated_at: new Date()
      }
    })

    return NextResponse.json(updatedHunter)
  } catch (error) {
    console.error(error)
    return NextResponse.json({ error: "Hunter not found" }, { status: 404 })
  }
}

export async function DELETE(
  request: Request,
  { params }: { params: Promise<{ id: string }> }
) {
  const { id } = await params

  await prisma.hunters.delete({
    where: {
      id: BigInt(id),
    },
  })

  return NextResponse.json({
    message: "Hunter deleted",
  })
}
