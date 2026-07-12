import { CheckCircle } from "lucide-react";

const HEX_CLIP = { clipPath: "polygon(25% 3%, 75% 3%, 100% 50%, 75% 97%, 25% 97%, 0% 50%)" };

export default function Advantages() {
  return (
    <section className="py-24 bg-white dark:bg-[#0F1626] overflow-hidden font-body">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="inline-block text-sm font-bold tracking-widest text-[#E8890C] dark:text-[#FFB627] uppercase mb-3 px-3 py-1 rounded-full bg-[#FFF1D6] dark:bg-[#1B2540]">
            Keunggulan
          </h2>
          <h3 className="font-display font-semibold text-3xl md:text-4xl text-[#1B2540] dark:text-white mb-6">
            Kenapa Sekolah Pilih HiveEdu?
          </h3>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-8">
            {[
              {
                title: "Desain Intuitif",
                desc: "Antarmuka yang bersih dan mudah dinavigasi, biar staf baru maupun orang tua nggak butuh training berhari-hari.",
              },
              {
                title: "Berbasis Cloud",
                desc: "Akses sistem kapan saja, di mana saja dari perangkat apa pun tanpa perlu instalasi rumit.",
              },
              {
                title: "Hemat Waktu & Biaya",
                desc: "Otomatisasi tugas repetitif dan kurangi penggunaan kertas secara signifikan.",
              },
            ].map((adv, idx) => (
              <div key={idx} className="flex gap-4">
                <div className="mt-1">
                  <div
                    style={HEX_CLIP}
                    className="w-10 h-10 bg-[#FFF1D6] dark:bg-[#1B2540] flex items-center justify-center text-[#E8890C] dark:text-[#FFB627]"
                  >
                    <CheckCircle size={18} />
                  </div>
                </div>
                <div>
                  <h4 className="text-xl font-display font-semibold text-[#1B2540] dark:text-white mb-2">
                    {adv.title}
                  </h4>
                  <p className="text-[#4A4438] dark:text-zinc-400">{adv.desc}</p>
                </div>
              </div>
            ))}
          </div>

          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-r from-[#FFB627] to-[#2FA8E0] rounded-[2.5rem] transform rotate-3 opacity-20 blur-lg" />
            <div className="relative bg-white dark:bg-[#141B2E] rounded-[2.5rem] p-8 border-2 border-[#FFE1A8] dark:border-[#26314D] shadow-2xl -rotate-1">
              <div className="space-y-6">
                {[1, 2, 3].map((i) => (
                  <div
                    key={i}
                    className="flex items-center gap-4 p-4 rounded-2xl bg-[#FFFBF2] dark:bg-[#0F1626] border border-[#FFE1A8]/70 dark:border-[#26314D]"
                  >
                    <div className="w-12 h-12 rounded-full bg-gradient-to-br from-[#FFE1A8] to-[#FFB627] animate-pulse" />
                    <div className="flex-1 space-y-2">
                      <div className="h-4 bg-[#FFE1A8]/70 dark:bg-[#26314D] rounded w-3/4 animate-pulse" />
                      <div className="h-3 bg-[#FFE1A8]/50 dark:bg-[#26314D] rounded w-1/2 animate-pulse" />
                    </div>
                  </div>
                ))}
              </div>
              <div className="absolute -bottom-6 -left-6 bg-[#1B2540] text-white p-6 rounded-2xl shadow-xl border-2 border-[#2E3B5C] rotate-2">
                <p className="text-3xl font-display font-bold mb-1 text-[#FFB627]">99.9%</p>
                <p className="text-sm font-medium opacity-90">Uptime Terjamin</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
