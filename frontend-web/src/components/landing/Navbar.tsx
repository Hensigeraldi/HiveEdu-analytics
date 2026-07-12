"use client";

import { useState, useEffect } from "react";
import Link from "next/link";
import { Menu, X, BookOpen } from "lucide-react";

/**
 * Font setup (add once in app/globals.css):
 *
 * @import url('https://fonts.googleapis.com/css2?family=Fredoka:wght@500;600;700&family=Plus+Jakarta+Sans:wght@400;500;600;700&display=swap');
 *
 * :root {
 *   --font-display: 'Fredoka', ui-rounded, sans-serif;
 *   --font-body: 'Plus Jakarta Sans', sans-serif;
 * }
 *
 * Then use className="font-[var(--font-display)]" for headings (already wired below via
 * the `font-display` / `font-body` utility classes — add these to tailwind.config.js:
 *
 * fontFamily: {
 *   display: ['Fredoka', 'ui-rounded', 'sans-serif'],
 *   body: ['"Plus Jakarta Sans"', 'sans-serif'],
 * }
 */

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

export default function Navbar() {
  const [isScrolled, setIsScrolled] = useState(false);
  const [isMobileMenuOpen, setIsMobileMenuOpen] = useState(false);

  useEffect(() => {
    const handleScroll = () => setIsScrolled(window.scrollY > 10);
    window.addEventListener("scroll", handleScroll);
    return () => window.removeEventListener("scroll", handleScroll);
  }, []);

  const navLinks = [
    { name: "Home", href: "#home" },
    { name: "Tentang", href: "#about" },
    { name: "Fitur", href: "#features" },
    { name: "Kontak", href: "#contact" },
  ];

  return (
    <header
      className={`fixed top-0 w-full z-50 transition-all duration-300 font-body ${
        isScrolled
          ? "bg-[#FFFBF2]/90 dark:bg-[#12182B]/90 backdrop-blur-md shadow-[0_4px_20px_-6px_rgba(232,137,12,0.25)] border-b border-[#FFE1A8] dark:border-[#26314D] py-3"
          : "bg-transparent py-5"
      }`}
    >
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="flex justify-between items-center">
          {/* Logo — hex "honeycomb" mark instead of a plain rounded square */}
          <Link href="#home" className="flex items-center gap-2.5 group">
            <div
              style={HEX_CLIP}
              className="bg-gradient-to-br from-[#FFB627] to-[#E8890C] text-[#1B2540] p-2.5 group-hover:rotate-[18deg] transition-transform duration-300"
            >
              <BookOpen size={22} strokeWidth={2.5} />
            </div>
            <span className="font-display font-semibold text-xl tracking-tight text-[#1B2540] dark:text-white">
              Hive<span className="text-[#E8890C]">Edu</span>
            </span>
          </Link>

          {/* Desktop Navigation */}
          <nav className="hidden md:flex items-center gap-1">
            {navLinks.map((link) => (
              <Link
                key={link.name}
                href={link.href}
                className="px-4 py-2 rounded-full text-sm font-semibold text-[#4A4438] hover:text-[#E8890C] hover:bg-[#FFF1D6] dark:text-zinc-300 dark:hover:text-[#FFB627] dark:hover:bg-[#1B2540] transition-colors"
              >
                {link.name}
              </Link>
            ))}
          </nav>

          {/* Login Button (Desktop) */}
          <div className="hidden md:flex items-center">
            <Link
              href="/login"
              className="px-6 py-2.5 text-sm font-bold text-[#1B2540] bg-[#FFB627] hover:bg-[#FFC658] rounded-full shadow-[0_4px_0_0_#E8890C] hover:shadow-[0_2px_0_0_#E8890C] hover:translate-y-[2px] transition-all active:translate-y-[4px] active:shadow-none"
            >
              Masuk 🐝
            </Link>
          </div>

          {/* Mobile Menu Button */}
          <button
            className="md:hidden p-2 text-[#1B2540] dark:text-zinc-200"
            onClick={() => setIsMobileMenuOpen(!isMobileMenuOpen)}
            aria-label="Buka menu"
          >
            {isMobileMenuOpen ? <X size={24} /> : <Menu size={24} />}
          </button>
        </div>
      </div>

      {/* Mobile Navigation */}
      {isMobileMenuOpen && (
        <div className="md:hidden absolute top-full left-0 w-full bg-[#FFFBF2] dark:bg-[#141B2E] border-b border-[#FFE1A8] dark:border-[#26314D] shadow-lg py-4 px-4 flex flex-col gap-2">
          {navLinks.map((link) => (
            <Link
              key={link.name}
              href={link.href}
              className="text-base font-semibold text-[#4A4438] hover:text-[#E8890C] dark:text-zinc-300 dark:hover:text-[#FFB627] transition-colors py-2 px-3 rounded-xl hover:bg-[#FFF1D6] dark:hover:bg-[#1B2540]"
              onClick={() => setIsMobileMenuOpen(false)}
            >
              {link.name}
            </Link>
          ))}
          <div className="pt-2 mt-2 border-t border-[#FFE1A8] dark:border-[#26314D]">
            <Link
              href="/login"
              className="flex justify-center w-full px-6 py-3 text-sm font-bold text-[#1B2540] bg-[#FFB627] hover:bg-[#FFC658] rounded-xl shadow-[0_4px_0_0_#E8890C] transition-all"
              onClick={() => setIsMobileMenuOpen(false)}
            >
              Masuk 🐝
            </Link>
          </div>
        </div>
      )}
    </header>
  );
}
