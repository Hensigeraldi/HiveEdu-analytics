"use client";

import Link from "next/link";
import { ArrowRight, Sparkles } from "lucide-react";

export default function Hero() {
  return (
    <section
      id="home"
      className="relative min-h-screen flex items-center justify-center pt-20 overflow-hidden bg-white dark:bg-black"
    >
      {/* Background Gradients */}
      <div className="absolute inset-0 w-full h-full bg-white dark:bg-black [mask-image:radial-gradient(ellipse_at_center,transparent_20%,black)]"></div>
      <div className="absolute top-0 -translate-y-[10%] left-1/2 -translate-x-1/2 w-[800px] h-[600px] bg-blue-500/20 dark:bg-blue-500/10 blur-[120px] rounded-full pointer-events-none"></div>

      <div className="relative z-10 max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 text-center flex flex-col items-center">
        <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-blue-50 dark:bg-blue-900/30 text-blue-600 dark:text-blue-400 text-sm font-medium mb-8 border border-blue-100 dark:border-blue-800/50">
          <Sparkles size={16} />
          <span>Platform Edukasi Masa Depan</span>
        </div>

        <h1 className="text-5xl md:text-7xl font-extrabold tracking-tight text-zinc-900 dark:text-white max-w-4xl mb-6">
          Solusi Terpadu untuk{" "}
          <span className="text-transparent bg-clip-text bg-gradient-to-r from-blue-600 to-cyan-500">
            Manajemen Sekolah
          </span>
        </h1>

        <p className="text-lg md:text-xl text-zinc-600 dark:text-zinc-400 max-w-2xl mb-10 leading-relaxed">
          Tingkatkan efisiensi administrasi, pantau perkembangan siswa, dan
          fasilitasi komunikasi yang lebih baik antara sekolah, guru, dan orang
          tua dalam satu platform digital terintegrasi.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto">
          <Link
            href="/login"
            className="flex items-center justify-center gap-2 px-8 py-4 text-base font-semibold text-white bg-blue-600 hover:bg-blue-700 rounded-full shadow-lg shadow-blue-600/25 transition-all hover:scale-105 active:scale-95"
          >
            Mulai Sekarang
            <ArrowRight size={20} />
          </Link>
          <Link
            href="#about"
            className="flex items-center justify-center px-8 py-4 text-base font-semibold text-zinc-700 dark:text-zinc-300 bg-white dark:bg-zinc-900 border border-zinc-200 dark:border-zinc-800 hover:bg-zinc-50 dark:hover:bg-zinc-800 rounded-full transition-all"
          >
            Pelajari Lebih Lanjut
          </Link>
        </div>
      </div>
    </section>
  );
}
