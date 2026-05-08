"use server"

import {prisma} from "@/lib/prisma"
import { revalidatePath } from "next/cache"
import { missionSchema } from "@/lib/validations/mission"

export async function createMission(formData: FormData) {
  try {
    const rawData = {
      hunterId: formData.get("hunterId"),
      bountyId: formData.get("bountyId"),
      notes: formData.get("notes"),
    }

    const validatedData =
      missionSchema.parse(rawData)

    await prisma.missions.create({
      data: {
        notes: validatedData.notes,
        completed: false,
        created_at: new Date(),
        updated_at: new Date(),

        hunters: {
          connect: {
            id: BigInt(validatedData.hunterId),
          },
        },

        bounties: {
          connect: {
            id: BigInt(validatedData.bountyId),
          },
        },
      },
    })

    revalidatePath("/missions")

    return {
      success: true,
    }

  } catch (error) {
  console.error(error)

  if (error instanceof Error) {
    return {
      error: error.message,
    }
  }

  return {
    error: "Something went wrong",
  }
}
}
export async function updateMission(formData: FormData) {
  const id = formData.get("id") as string
  const notes = formData.get("notes") as string

  await prisma.missions.update({
    where: {
      id: BigInt(id),
    },
    data: {
      notes,
      updated_at: new Date(),
    },
  })

  revalidatePath("/missions")
}

export async function deleteMission(formData: FormData) {
  const id = formData.get("id") as string

  await prisma.missions.delete({
    where: {
      id: BigInt(id),
    },
  })

  revalidatePath("/missions")
}