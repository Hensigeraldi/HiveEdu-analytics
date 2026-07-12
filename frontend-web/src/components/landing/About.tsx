import { CheckCircle2 } from "lucide-react";

export default function About() {
  return (
    <section id="about" className="py-24 bg-zinc-50 dark:bg-zinc-950">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="grid lg:grid-cols-2 gap-16 items-center">
          <div className="order-2 lg:order-1 relative">
            <div className="aspect-square md:aspect-[4/3] lg:aspect-square bg-gradient-to-tr from-blue-100 to-blue-50 dark:from-blue-900/20 dark:to-blue-800/10 rounded-3xl overflow-hidden border border-blue-200/50 dark:border-blue-800/30 relative flex items-center justify-center">
              {/* Abstract decorative shapes instead of an image placeholder */}
              <div className="absolute w-64 h-64 bg-blue-400/20 dark:bg-blue-600/20 rounded-full blur-3xl -top-10 -left-10"></div>
              <div className="absolute w-64 h-64 bg-cyan-400/20 dark:bg-cyan-600/20 rounded-full blur-3xl -bottom-10 -right-10"></div>
              
              <div className="relative z-10 text-center p-8 bg-white/60 dark:bg-zinc-900/60 backdrop-blur-xl border border-white/20 dark:border-zinc-700/50 rounded-2xl shadow-xl max-w-sm">
                <div className="flex -space-x-4 justify-center mb-6">
                  {[1, 2, 3, 4].map((i) => (
                    <div key={i} className={`w-12 h-12 rounded-full border-2 border-white dark:border-zinc-800 flex items-center justify-center bg-zinc-100 dark:bg-zinc-800 z-${5-i}`}>
                       <span className="text-xs text-zinc-500 font-medium">U{i}</span>
                    </div>
                  ))}
                </div>
                <h3 className="text-xl font-bold text-zinc-900 dark:text-white mb-2">Dipercaya oleh Sekolah</h3>
                <p className="text-sm text-zinc-600 dark:text-zinc-400">Ribuan pengguna aktif setiap harinya mengandalkan sistem kami.</p>
              </div>
            </div>
          </div>

          <div className="order-1 lg:order-2">
            <h2 className="text-sm font-bold tracking-widest text-blue-600 uppercase mb-3">
              Tentang Kami
            </h2>
            <h3 className="text-3xl md:text-4xl font-bold text-zinc-900 dark:text-white mb-6 leading-tight">
              Transformasi Digital untuk Institusi Pendidikan
            </h3>
            <p className="text-lg text-zinc-600 dark:text-zinc-400 mb-8 leading-relaxed">
              HiveEdu dirancang khusus untuk memenuhi kebutuhan manajemen sekolah
              modern. Kami mengintegrasikan seluruh aspek operasional sekolah—dari
              penilaian, administrasi, hingga komunikasi—ke dalam satu ekosistem
              yang mulus dan mudah digunakan.
            </p>

            <ul className="space-y-5">
              {[
                "Sistem terpusat untuk semua data akademik.",
                "Akses real-time bagi guru, siswa, dan orang tua.",
                "Keamanan data setara standar industri perbankan.",
                "Dukungan teknis responsif 24/7.",
              ].map((item, idx) => (
                <li key={idx} className="flex items-start gap-3">
                  <CheckCircle2
                    className="text-blue-500 mt-1 flex-shrink-0"
                    size={20}
                  />
                  <span className="text-zinc-700 dark:text-zinc-300">{item}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>
      </div>
    </section>
  );
}
