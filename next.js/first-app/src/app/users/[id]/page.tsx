export default async function UserPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>
  searchParams: Promise<{ name?: string }>
}) {
  const { id } = await params
  const { name } = await searchParams

  return (
    <div className="p-10">
      <h1 className="text-4xl font-bold mb-4">
        User ID: {id}
      </h1>

      <h2 className="text-2xl">
        Name: {name}
      </h2>
    </div>
  )
}