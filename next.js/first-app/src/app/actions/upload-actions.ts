"use server"

import fs from "fs/promises"
import path from "path"

export async function uploadImage(
  prevState: any,
  formData: FormData
) {

  try {

    const file =
      formData.get("image") as File

    if (!file || file.size === 0) {
      return {
        success: "",
        error: "No file selected",
      }
    }

    const bytes =
      await file.arrayBuffer()

    const buffer =
      Buffer.from(bytes)

    const fileExtension =
      file.name.split(".").pop()

    const fileName =
      `${crypto.randomUUID()}.${fileExtension}`

    const uploadPath =
      path.join(
        process.cwd(),
        "public/uploads",
        fileName
      )

    await fs.writeFile(
      uploadPath,
      buffer
    )

    return {
      success:
        `/uploads/${fileName}`,

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
