import Link from 'next/link'


type NavbarProps = {
  title: string
}
export default function Navbar({ title }: NavbarProps) {
  return (
    <nav className="bg-gray-800 text-white p-4">
      <ul className="flex space-x-4">
        <li>{title}</li>
        <li>
          <Link href="/" className="hover:underline">
            Home
          </Link>
        </li>
        <li>
          <Link href="/about" className="hover:underline">
            About
          </Link>
        </li>
        <li>
          <Link href="/contact" className="hover:underline">
            Contact
          </Link>
        </li>

        <li>
          <Link href="/users" className="hover:underline">
            Users
          </Link>
        </li>
      </ul>
    </nav>
  )
}
