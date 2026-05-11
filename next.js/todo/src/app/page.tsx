export default function HomePage() {
  return (
    <main className="mx-auto flex min-h-screen max-w-5xl items-center px-6 py-16">
      <section className="w-full rounded-3xl border border-[var(--border)] bg-[var(--surface)] p-10 shadow-sm">
        <p className="text-sm font-semibold uppercase tracking-[0.2em] text-[var(--accent)]">
          Task Management
        </p>
        <h1 className="mt-4 text-5xl font-bold tracking-tight text-zinc-950">
          Production Todo App
        </h1>
        <p className="mt-4 max-w-2xl text-lg text-[var(--muted-foreground)]">
          A clean light workspace for signing in, creating tasks, and managing your daily queue.
        </p>
      </section>
    </main>
  );
}
