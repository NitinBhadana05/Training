"use server"

import {prisma} from "@/lib/prisma"
import { revalidatePath } from "next/cache"

export async function createBounty(
  prevState: {
    success: string
    error: string
  },
  formData: FormData
) {
  try {
    const targetName =
      formData.get("targetName") as string

    const rewardAmount =
      formData.get("rewardAmount") as string

    const threatLevel =
      formData.get("threatLevel") as string

    if (
      !targetName ||
      !rewardAmount ||
      !threatLevel
    ) {
      return {
        success: "",
        error: "All fields are required",
      }
    }

    await prisma.bounties.create({
      data: {
        target_name: targetName,
        reward_amount: Number(rewardAmount),
        threat_level: Number(threatLevel),
        status: "Active",
        created_at: new Date(),
        updated_at: new Date(),
      },
    })

    revalidatePath("/bounties")

    return {
      success: "Bounty created successfully",
      error: "",
    }

  } catch (error: any) {
    console.error(error)

    return {
      success: "",
      error: error.message,
    }
  }
}