export default async function PostsPage() {
  const response = await fetch(
    "https://jsonplaceholder.typicode.com/posts"
  )

  const posts = await response.json()

  return (
    <main className="p-10">
      <h1 className="text-4xl font-bold mb-6">
        Posts
      </h1>

      {posts.slice(0, 5).map((post: { id: number; title: string }) => (
        <div
          key={post.id}
          className="border p-4 mb-4 rounded"
        >
          <h2 className="font-bold text-xl">
            {post.title}
          </h2>
        </div>
      ))}
    </main>
  )
}