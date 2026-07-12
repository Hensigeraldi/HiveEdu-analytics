import { CheckCircle2 } from "lucide-react";

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

export default function About() {
  return (
    <section id="about" className="py-24 bg-white dark:bg-[#0F1626] font-body overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="order-2 lg:order-1 relative">
            <div className="aspect-square md:aspect-[4/3] lg:aspect-square bg-gradient-to-tr from-[#FFF1D6] to-[#FFFBF2] dark:from-[#1B2540] dark:to-[#141B2E] rounded-[2.5rem] overflow-hidden border-2 border-[#FFE1A8] dark:border-[#26314D] relative flex items-center justify-center rotate-1">
              {/* Honeycomb accents instead of a generic image placeholder */}
              <div
                style={HEX_CLIP}
                className="absolute w-28 h-28 bg-[#FFB627]/30 dark:bg-[#FFB627]/20 blur-2xl -top-6 -left-6"
              />
              <div
                style={HEX_CLIP}
                className="absolute w-28 h-28 bg-[#2FA8E0]/20 dark:bg-[#2FA8E0]/20 blur-2xl -bottom-6 -right-6"
              />

              <div className="relative z-10 text-center p-8 bg-white/80 dark:bg-[#1B2540]/80 backdrop-blur-xl border-2 border-white dark:border-[#2E3B5C] rounded-[1.75rem] shadow-xl max-w-sm -rotate-2">
                <div className="flex -space-x-4 justify-center mb-6">
                  {[1, 2, 3, 4].map((i) => (
                    <div
                      key={i}
                      className={`w-12 h-12 rounded-full border-2 border-white dark:border-[#1B2540] flex items-center justify-center bg-gradient-to-br from-[#FFE1A8] to-[#FFB627] z-${5 - i}`}
                    >
                      <span className="text-xs text-[#1B2540] font-bold">U{i}</span>
                    </div>
                  ))}
                </div>
                <h3 className="text-xl font-display font-semibold text-[#1B2540] dark:text-white mb-2">
                  Dipercaya oleh Sekolah
                </h3>
                <p className="text-sm text-[#4A4438] dark:text-zinc-400">
                  Ribuan pengguna aktif setiap harinya mengandalkan sistem kami — dan
                  betah, bukan cuma terpaksa.
                </p>
              </div>
            </div>
          </div>

          <div className="order-1 lg:order-2">
            <h2 className="inline-block text-sm font-bold tracking-widest text-[#E8890C] dark:text-[#FFB627] uppercase mb-3 px-3 py-1 rounded-full bg-[#FFF1D6] dark:bg-[#1B2540]">
              Tentang Kami
            </h2>
            <h3 className="font-display font-semibold text-3xl md:text-4xl text-[#1B2540] dark:text-white mb-6 leading-tight">
              Satu Sarang untuk Semua Urusan Sekolah
            </h3>
            <p className="text-lg text-[#4A4438] dark:text-zinc-400 mb-8 leading-relaxed">
              HiveEdu dirancang khusus untuk kebutuhan manajemen sekolah modern —
              tanpa harus terasa kaku seperti software administrasi kebanyakan. Kami
              satukan penilaian, administrasi, hingga komunikasi jadi satu ekosistem
              yang enak dipakai setiap hari.
            </p>
            <ul className="space-y-5">
              {[
                "Sistem terpusat untuk semua data akademik.",
                "Akses real-time bagi guru, siswa, dan orang tua.",
                "Keamanan data setara standar industri perbankan.",
                "Dukungan teknis responsif 24/7.",
              ].map((item, idx) => (
                <li key={idx} className="flex items-start gap-3">
                  <span className="mt-0.5 flex-shrink-0 w-6 h-6 rounded-full bg-[#FFF1D6] dark:bg-[#1B2540] flex items-center justify-center">
                    <CheckCircle2 className="text-[#E8890C] dark:text-[#FFB627]" size={16} />
                  </span>
                  <span className="text-[#1B2540]/80 dark:text-zinc-300">{item}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
