import Link from "next/link";
import { BookOpen, Mail, Phone, MapPin, Globe } from "lucide-react";

export default function Footer() {
  return (
    <footer id="contact" className="bg-zinc-50 dark:bg-zinc-950 pt-20 pb-10 border-t border-zinc-200 dark:border-zinc-900">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
          <div className="md:col-span-2 space-y-6">
            <Link href="#home" className="flex items-center gap-2 group inline-flex">
              <div className="bg-blue-600 text-white p-2 rounded-xl">
                <BookOpen size={24} />
              </div>
              <span className="font-bold text-xl tracking-tight text-zinc-900 dark:text-white">
                HiveEdu
              </span>
            </Link>
            <p className="text-zinc-600 dark:text-zinc-400 max-w-sm leading-relaxed">
              Membangun masa depan pendidikan yang lebih baik melalui teknologi yang tepat guna dan mudah diakses oleh semua kalangan.
            </p>
            <div className="flex gap-4">
              {[Mail, Phone, MapPin, Globe].map((Icon, i) => (
                <a
                  key={i}
                  href="#"
                  className="w-10 h-10 rounded-full bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 flex items-center justify-center text-zinc-600 dark:text-zinc-400 hover:text-blue-600 hover:border-blue-600 dark:hover:text-blue-400 dark:hover:border-blue-400 transition-colors"
                >
                  <Icon size={18} />
                </a>
              ))}
            </div>
          </div>

          <div>
            <h4 className="font-bold text-zinc-900 dark:text-white mb-6">Tautan</h4>
            <ul className="space-y-4">
              {["Home", "About", "Features", "Contact"].map((item) => (
                <li key={item}>
                  <Link
                    href={`#${item.toLowerCase()}`}
                    className="text-zinc-600 dark:text-zinc-400 hover:text-blue-600 dark:hover:text-blue-400 transition-colors"
                  >
                    {item}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="font-bold text-zinc-900 dark:text-white mb-6">Kontak</h4>
            <ul className="space-y-4 text-zinc-600 dark:text-zinc-400">
              <li>info@hiveedu.com</li>
              <li>+62 812 3456 7890</li>
              <li>Jakarta, Indonesia</li>
            </ul>
          </div>
        </div>

        <div className="pt-8 border-t border-zinc-200 dark:border-zinc-800 text-center text-zinc-500 dark:text-zinc-500 text-sm">
          <p>&copy; {new Date().getFullYear()} HiveEdu. Seluruh hak cipta dilindungi.</p>
        </div>
      </div>
    </footer>
  );
}
