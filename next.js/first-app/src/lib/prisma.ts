// Important: Import from the folder you created, not @prisma/client
import { PrismaClient } from "../generated/prisma/client"
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'

const connectionString = process.env.DATABASE_URL
const pool = new pg.Pool({ connectionString })
const adapter = new PrismaPg(pool)

// Initialize with the adapter (required for Prisma 7)
export const prisma = new PrismaClient({ adapter })

export default prisma