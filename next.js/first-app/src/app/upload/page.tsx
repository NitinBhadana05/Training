"use client"

import Image from "next/image"

import { useActionState }
from "react"

import {
  uploadImage
} from "@/app/actions/upload-actions"

const initialState = {
  success: "",
  error: "",
}

export default function UploadPage() {

  const [state, formAction, pending] =
    useActionState(
      uploadImage,
      initialState
    )

  return (
    <main className="p-10 max-w-xl mx-auto">

      <h1 className="text-4xl font-bold mb-6">
        Upload Image
      </h1>

      <form
        action={formAction}
        className="space-y-4"
      >

        {state.error && (
          <p className="text-red-500">
            {state.error}
          </p>
        )}

        <input
          type="file"
          name="image"
          className="border p-2 rounded w-full"
        />

        <button
          type="submit"
          disabled={pending}
          className="bg-black text-white px-4 py-2 rounded"
        >
          {pending
            ? "Uploading..."
            : "Upload"}
        </button>
      </form>

      {state.success && (
        <div className="mt-6">

          <p className="mb-2">
            Uploaded Successfully
          </p>

          <Image
            src={state.success}
            alt="Uploaded Image"
            width={300}
            height={300}
            className="rounded"
          />
        </div>
      )}
    </main>
  )
}