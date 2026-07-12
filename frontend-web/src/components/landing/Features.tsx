import { BookOpen, Users, LineChart, ShieldCheck, Clock, MessageSquare } from "lucide-react";

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

const features = [
  {
    icon: <Users className="text-[#2FA8E0]" size={26} />,
    title: "Manajemen Pengguna",
    description: "Kelola data siswa, guru, staf, dan orang tua dalam satu dashboard yang rapi dan mudah diakses.",
    tint: "bg-[#E6F5FF] dark:bg-[#12233A]",
  },
  {
    icon: <BookOpen className="text-[#E8890C]" size={26} />,
    title: "E-Raport & Penilaian",
    description: "Sistem penilaian terpadu yang memudahkan guru menginput nilai dan mencetak raport otomatis.",
    tint: "bg-[#FFF1D6] dark:bg-[#2A2013]",
  },
  {
    icon: <LineChart className="text-[#7C6AE8]" size={26} />,
    title: "Analitik & Pelaporan",
    description: "Pantau perkembangan akademik siswa lewat grafik dan laporan statistik yang komprehensif.",
    tint: "bg-[#EFEBFF] dark:bg-[#201B3A]",
  },
  {
    icon: <MessageSquare className="text-[#E85D9E]" size={26} />,
    title: "Portal Komunikasi",
    description: "Jembatani komunikasi antara sekolah dan orang tua siswa untuk transparansi yang lebih baik.",
    tint: "bg-[#FFEAF3] dark:bg-[#301C28]",
  },
  {
    icon: <Clock className="text-[#F2790C]" size={26} />,
    title: "Jadwal Terintegrasi",
    description: "Atur jadwal pelajaran, ujian, dan ekstrakurikuler tanpa bentrok dengan sistem cerdas kami.",
    tint: "bg-[#FFE9D6] dark:bg-[#2E2013]",
  },
  {
    icon: <ShieldCheck className="text-[#2BB673]" size={26} />,
    title: "Keamanan Data",
    description: "Privasi dan keamanan data sekolah Anda terjamin dengan enkripsi mutakhir dan backup berkala.",
    tint: "bg-[#E6F9EF] dark:bg-[#122A1E]",
  },
];

export default function Features() {
  return (
    <section id="features" className="py-24 bg-[#FFFBF2] dark:bg-[#0F1626] font-body">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="inline-block text-sm font-bold tracking-widest text-[#E8890C] dark:text-[#FFB627] uppercase mb-3 px-3 py-1 rounded-full bg-[#FFF1D6] dark:bg-[#1B2540]">
            Fitur Utama
          </h2>
          <h3 className="font-display font-semibold text-3xl md:text-4xl text-[#1B2540] dark:text-white mb-6">
            Semua yang Sekolah Anda Butuhkan
          </h3>
          <p className="text-lg text-[#4A4438] dark:text-zinc-400">
            Fitur-fitur kami dirancang berdasarkan masukan dari ratusan praktisi
            pendidikan — biar relevan, biar kepakai, bukan cuma nampang di brosur.
          </p>
        </div>

        <div className="grid md:grid-cols-2 lg:grid-cols-3 gap-8">
          {features.map((feature, idx) => (
            <div
              key={idx}
              className="p-8 rounded-[2rem] bg-white dark:bg-[#141B2E] border-2 border-[#FFE1A8]/70 dark:border-[#26314D] hover:-translate-y-1.5 hover:shadow-xl hover:shadow-[#FFB627]/10 transition-all duration-300 group"
            >
              <div
                style={HEX_CLIP}
                className={`w-16 h-16 ${feature.tint} flex items-center justify-center mb-6 group-hover:rotate-[18deg] transition-transform duration-300`}
              >
                {feature.icon}
              </div>
              <h4 className="text-xl font-display font-semibold text-[#1B2540] dark:text-white mb-3">
                {feature.title}
              </h4>
              <p className="text-[#4A4438] dark:text-zinc-400 leading-relaxed">{feature.description}</p>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
}
