import { z } from "zod"

export const missionSchema = z.object({
  hunterId: z.string().min(1, "Hunter is required"),

  bountyId: z.string().min(1, "Bounty is required"),

  notes: z
    .string()
    .min(5, "Notes must be at least 5 characters"),
})