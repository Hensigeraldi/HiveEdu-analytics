import Link from "next/link";
import { ArrowRight } from "lucide-react";

function HexOutline({ className, color = "#FFFBF2" }: { className?: string; color?: string }) {
  return (
    <svg viewBox="0 0 100 116" className={className} fill="none" aria-hidden="true">
      <path
        d="M50 2 L96 29 V87 L50 114 L4 87 V29 Z"
        stroke={color}
        strokeWidth="4"
        strokeOpacity="0.25"
      />
    </svg>
  );
}

export default function CTA() {
  return (
    <section className="relative py-24 bg-[#1B2540] overflow-hidden font-body">
      {/* Honeycomb scatter to echo the hero, keeping the brand consistent */}
      <HexOutline className="hidden md:block absolute w-24 top-10 left-[8%] rotate-6" />
      <HexOutline className="hidden md:block absolute w-16 bottom-10 left-[20%] -rotate-12" />
      <HexOutline className="hidden md:block absolute w-28 top-8 right-[10%] -rotate-6" color="#FFB627" />
      <HexOutline className="hidden md:block absolute w-20 bottom-14 right-[22%] rotate-12" color="#FFB627" />

      <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-[600px] h-[400px] bg-[#FFB627]/10 blur-[120px] rounded-full pointer-events-none" />

      <div className="relative z-10 max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 text-center">
        <div className="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/10 text-[#FFB627] text-sm font-bold mb-6 border border-white/10">
          <span>🐝 Gratis 14 hari, tanpa kartu kredit</span>
        </div>

        <h3 className="font-display font-semibold text-3xl md:text-5xl text-white mb-6 leading-tight">
          Siap Bikin Sekolahmu Makin Kece?
        </h3>
        <p className="text-lg text-zinc-300 mb-10 max-w-2xl mx-auto leading-relaxed">
          Ratusan sekolah sudah pindah dari spreadsheet berantakan ke HiveEdu.
          Giliran sekolahmu — daftarkan timmu hari ini dan langsung terasa bedanya.
        </p>

        <div className="flex flex-col sm:flex-row gap-4 w-full sm:w-auto justify-center">
          <Link
            href="/login"
            className="flex items-center justify-center gap-2 px-8 py-4 text-base font-bold text-[#1B2540] bg-[#FFB627] hover:bg-[#FFC658] rounded-full shadow-[0_6px_0_0_#E8890C] hover:shadow-[0_3px_0_0_#E8890C] hover:translate-y-[3px] transition-all active:translate-y-[6px] active:shadow-none"
          >
            Mulai Sekarang
            <ArrowRight size={20} />
          </Link>
          <Link
            href="#contact"
            className="flex items-center justify-center px-8 py-4 text-base font-bold text-white bg-white/10 hover:bg-white/20 border border-white/15 rounded-full transition-all"
          >
            Hubungi Tim Kami
          </Link>
        </div>
      </div>
    </section>
  );
}
