export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <div className="flex flex-col min-h-screen">
      
     
      <div className="flex grow">
        
        <aside className="w-64 bg-black text-white p-4">
          Dashboard Sidebar
        </aside>

        <main className="flex grow p-10">
          {children}
        </main>
      </div>

    
      <footer className="w-full bg-gray-800 text-white p-4 text-center">
        © 2026 Your Brand
      </footer>
    </div>
  )
}