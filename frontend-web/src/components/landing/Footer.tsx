import Link from "next/link";
import { BookOpen, Mail, Phone, MapPin, Globe } from "lucide-react";

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

export default function Footer() {
  return (
    <footer id="contact" className="bg-[#141B2E] pt-20 pb-10 border-t border-[#26314D] font-body">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-16">
          <div className="md:col-span-2 space-y-6">
            <Link href="#home" className="flex items-center gap-2.5 group inline-flex">
              <div
                style={HEX_CLIP}
                className="bg-gradient-to-br from-[#FFB627] to-[#E8890C] text-[#1B2540] p-2.5"
              >
                <BookOpen size={22} strokeWidth={2.5} />
              </div>
              <span className="font-display font-semibold text-xl tracking-tight text-white">
                Hive<span className="text-[#FFB627]">Edu</span>
              </span>
            </Link>
            <p className="text-zinc-400 max-w-sm leading-relaxed">
              Membangun masa depan pendidikan yang lebih baik lewat teknologi yang
              tepat guna, mudah diakses, dan enak dipakai oleh semua kalangan.
            </p>
            <div className="flex gap-3">
              {[Mail, Phone, MapPin, Globe].map((Icon, i) => (
                <a
                  key={i}
                  href="#"
                  style={HEX_CLIP}
                  className="w-10 h-10 bg-[#1B2540] border border-[#2E3B5C] flex items-center justify-center text-zinc-400 hover:text-[#1B2540] hover:bg-[#FFB627] transition-colors"
                >
                  <Icon size={16} />
                </a>
              ))}
            </div>
          </div>

          <div>
            <h4 className="font-display font-semibold text-white mb-6">Tautan</h4>
            <ul className="space-y-4">
              {["Home", "About", "Features", "Contact"].map((item) => (
                <li key={item}>
                  <Link
                    href={`#${item.toLowerCase()}`}
                    className="text-zinc-400 hover:text-[#FFB627] transition-colors"
                  >
                    {item}
                  </Link>
                </li>
              ))}
            </ul>
          </div>

          <div>
            <h4 className="font-display font-semibold text-white mb-6">Kontak</h4>
            <ul className="space-y-4 text-zinc-400">
              <li>info@hiveedu.com</li>
              <li>+62 812 3456 7890</li>
              <li>Jakarta, Indonesia</li>
            </ul>
          </div>
        </div>

        <div className="pt-8 border-t border-[#26314D] text-center text-zinc-500 text-sm">
          <p>&copy; {new Date().getFullYear()} HiveEdu. Seluruh hak cipta dilindungi. 🐝</p>
        </div>
      </div>
    </footer>
  );
}
