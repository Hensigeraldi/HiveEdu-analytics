import { BookOpen, Users, LineChart, ShieldCheck, Clock, MessageSquare } from "lucide-react";

const features = [
  {
    icon: <Users className="text-blue-500" size={28} />,
    title: "Manajemen Pengguna",
    description: "Kelola data siswa, guru, staf, dan orang tua dalam satu dashboard yang terstruktur rapi dan mudah diakses.",
  },
  {
    icon: <BookOpen className="text-cyan-500" size={28} />,
    title: "E-Raport & Penilaian",
    description: "Sistem penilaian terpadu yang memudahkan guru menginput nilai dan mencetak raport secara otomatis dan akurat.",
  },
  {
    icon: <LineChart className="text-indigo-500" size={28} />,
    title: "Analitik & Pelaporan",
    description: "Pantau perkembangan akademik siswa melalui grafik dan laporan statistik yang komprehensif secara real-time.",
  },
  {
    icon: <MessageSquare className="text-pink-500" size={28} />,
    title: "Portal Komunikasi",
    description: "Jembatani komunikasi antara pihak sekolah dan orang tua siswa untuk transparansi dan kolaborasi yang optimal.",
  },
  {
    icon: <Clock className="text-orange-500" size={28} />,
    title: "Jadwal Terintegrasi",
    description: "Atur jadwal pelajaran, ujian, dan kegiatan ekstrakurikuler tanpa bentrok dengan sistem cerdas kami.",
  },
  {
    icon: <ShieldCheck className="text-emerald-500" size={28} />,
    title: "Keamanan Data",
    description: "Privasi dan keamanan data sekolah Anda terjamin dengan enkripsi mutakhir dan backup berkala otomatis.",
  },
];

export default function Features() {
  return (
    <section id="features" className="py-24 bg-white dark:bg-black">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="text-sm font-bold tracking-widest text-blue-600 uppercase mb-3">
            Fitur Utama
          </h2>
          <h3 className="text-3xl md:text-4xl font-bold text-zinc-900 dark:text-white mb-6">
            Segala yang Anda Butuhkan untuk Mengelola Sekolah
          </h3>
          <p className="text-lg text-zinc-600 dark:text-zinc-400">
            Fitur-fitur kami dirancang khusus berdasarkan masukan dari ratusan praktisi pendidikan untuk memastikan relevansi dan kemudahan penggunaan.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, idx) => (
            <div
              key={idx}
              className="p-8 rounded-3xl bg-zinc-50 dark:bg-zinc-900 border border-zinc-100 dark:border-zinc-800 hover:shadow-xl hover:shadow-blue-500/5 transition-all duration-300 group"
            >
              <div className="w-14 h-14 rounded-2xl bg-white dark:bg-zinc-800 shadow-sm border border-zinc-100 dark:border-zinc-700 flex items-center justify-center mb-6 group-hover:scale-110 transition-transform duration-300">
                {feature.icon}
              </div>
              <h4 className="text-xl font-bold text-zinc-900 dark:text-white mb-3">
                {feature.title}
              </h4>
              <p className="text-zinc-600 dark:text-zinc-400 leading-relaxed">
                {feature.description}
              </p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
