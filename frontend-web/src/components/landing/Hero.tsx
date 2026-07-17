"use client";

import Link from "next/link";
import { ArrowRight, Sparkles, Users2 } from "lucide-react";

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

// Small decorative hexagon outline used to scatter the "honeycomb" motif
function HexOutline({ className, color = "#FFB627" }: { className?: string; color?: string }) {
  return (
    <svg viewBox="0 0 100 116" className={className} fill="none" aria-hidden="true">
      <path
        d="M50 2 L96 29 V87 L50 114 L4 87 V29 Z"
        stroke={color}
        strokeWidth="4"
        strokeOpacity="0.35"
      />
    </svg>
  );
}

export default function Hero() {
  return (
    <section
      id="home"
      className="relative min-h-screen flex items-center justify-center pt-24 pb-16 overflow-hidden bg-[#FFFBF2] dark:bg-[#0F1626] font-body"
    >
      {/* Honeycomb scatter — the recurring signature motif */}
      <HexOutline className="hidden md:block absolute w-24 top-28 left-[8%] rotate-6" color="#FFB627" />
      <HexOutline className="hidden md:block absolute w-16 top-1/2 left-[3%] -rotate-12" color="#2FA8E0" />
      <HexOutline className="hidden md:block absolute w-20 bottom-24 left-[14%] rotate-12" color="#FFB627" />
      <HexOutline className="hidden md:block absolute w-28 top-32 right-[6%] -rotate-6" color="#2FA8E0" />
      <HexOutline className="hidden md:block absolute w-16 bottom-32 right-[10%] rotate-3" color="#FFB627" />

      {/* Soft honey glow instead of a corporate blue blur */}
      <div className="absolute top-0 -translate-y-[10%] left-1/2 -translate-x-1/2 w-[800px] h-[600px] bg-[#FFB627]/25 dark:bg-[#FFB627]/10 blur-[120px] rounded-full pointer-events-none" />

      <div className="relative z-10 max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 text-center flex flex-col items-center">
        <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white dark:bg-[#1B2540] text-[#E8890C] dark:text-[#FFB627] text-sm font-bold mb-8 border-2 border-[#FFE1A8] dark:border-[#2E3B5C] shadow-[0_3px_0_0_#FFE1A8] dark:shadow-[0_3px_0_0_#2E3B5C] -rotate-1">
          <Sparkles size={16} />
          <span>Bukan software sekolah yang bikin boring 🐝</span>
        </div>

        <h1 className="font-display font-semibold text-5xl md:text-7xl tracking-tight text-[#1B2540] dark:text-white max-w-4xl mb-6 leading-[1.05]">
          Kelola Sekolah,{" "}
          <span className="relative inline-block">
            <span className="relative z-10 text-transparent bg-clip-text bg-gradient-to-r from-[#E8890C] to-[#FFB627]">
              Tanpa Drama
            </span>
            <svg
              className="absolute -bottom-2 left-0 w-full h-3 text-[#FFB627]/60"
              viewBox="0 0 200 12"
              preserveAspectRatio="none"
              aria-hidden="true"
            >
              <path d="M0 8 Q50 0 100 6 T200 4" stroke="currentColor" strokeWidth="6" fill="none" strokeLinecap="round" />
            </svg>
          </span>
        </h1>

        <p className="text-lg md:text-xl text-[#4A4438] dark:text-zinc-400 max-w-2xl mb-10 leading-relaxed">
          HiveEdu merapikan administrasi, memantau perkembangan siswa, dan menjaga
          komunikasi guru-orang tua tetap lancar jaya — semuanya dari satu tempat yang
          enak dipakai sehari-hari.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto">
          <Link
            href="/login"
            className="flex items-center justify-center gap-2 px-8 py-4 text-base font-bold text-[#1B2540] bg-[#FFB627] hover:bg-[#FFC658] rounded-full shadow-[0_6px_0_0_#E8890C] hover:shadow-[0_3px_0_0_#E8890C] hover:translate-y-[3px] transition-all active:translate-y-[6px] active:shadow-none"
          >
            Coba Gratis Sekarang
            <ArrowRight size={20} />
          </Link>
          <Link
            href="#about"
            className="flex items-center justify-center px-8 py-4 text-base font-bold text-[#1B2540] dark:text-zinc-200 bg-white dark:bg-[#1B2540] border-2 border-[#1B2540]/10 dark:border-zinc-700 hover:border-[#1B2540]/30 rounded-full transition-all"
          >
            Lihat Cara Kerjanya
          </Link>
        </div>

        <div className="mt-14 flex items-center gap-3 text-sm font-medium text-[#4A4438] dark:text-zinc-400">
          <div className="flex -space-x-3">
            {[1, 2, 3, 4].map((i) => (
              <div
                key={i}
                className="w-9 h-9 rounded-full border-2 border-[#FFFBF2] dark:border-[#0F1626] bg-gradient-to-br from-[#FFE1A8] to-[#FFB627] flex items-center justify-center text-xs font-bold text-[#1B2540]"
              >
                <Users2 size={14} />
              </div>
            ))}
          </div>
          <span>Dipercaya 500+ sekolah di seluruh Indonesia Tervalidasi</span>
        </div>
      </div>
    </section>
  );
}
