import { CheckCircle } from "lucide-react";

export default function Advantages() {
  return (
    <section className="py-24 bg-zinc-50 dark:bg-zinc-950 overflow-hidden">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
        <div className="text-center max-w-3xl mx-auto mb-16">
          <h2 className="text-sm font-bold tracking-widest text-blue-600 uppercase mb-3">
            Keunggulan
          </h2>
          <h3 className="text-3xl md:text-4xl font-bold text-zinc-900 dark:text-white mb-6">
            Mengapa Memilih HiveEdu?
          </h3>
        </div>

        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-8">
            {[
              {
                title: "Desain Intuitif",
                desc: "Antarmuka yang bersih dan mudah dinavigasi, meminimalisir waktu belajar bagi staf baru maupun orang tua.",
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
                  <div className="w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900/40 flex items-center justify-center text-blue-600 dark:text-blue-400">
                    <CheckCircle size={18} />
                  </div>
                </div>
                <div>
                  <h4 className="text-xl font-bold text-zinc-900 dark:text-white mb-2">
                    {adv.title}
                  </h4>
                  <p className="text-zinc-600 dark:text-zinc-400">
                    {adv.desc}
                  </p>
                </div>
              </div>
            ))}
          </div>

          <div className="relative">
            <div className="absolute inset-0 bg-gradient-to-r from-blue-500 to-cyan-500 rounded-3xl transform rotate-3 opacity-20 blur-lg"></div>
            <div className="relative bg-white dark:bg-zinc-900 rounded-3xl p-8 border border-zinc-200 dark:border-zinc-800 shadow-2xl">
              <div className="space-y-6">
                {[1, 2, 3].map((i) => (
                  <div key={i} className="flex items-center gap-4 p-4 rounded-2xl bg-zinc-50 dark:bg-zinc-950 border border-zinc-100 dark:border-zinc-800">
                    <div className="w-12 h-12 rounded-full bg-zinc-200 dark:bg-zinc-800 animate-pulse"></div>
                    <div className="flex-1 space-y-2">
                      <div className="h-4 bg-zinc-200 dark:bg-zinc-800 rounded w-3/4 animate-pulse"></div>
                      <div className="h-3 bg-zinc-200 dark:bg-zinc-800 rounded w-1/2 animate-pulse"></div>
                    </div>
                  </div>
                ))}
              </div>
              <div className="absolute -bottom-6 -left-6 bg-blue-600 text-white p-6 rounded-2xl shadow-xl border border-blue-500">
                <p className="text-3xl font-extrabold mb-1">99.9%</p>
                <p className="text-sm font-medium opacity-90">Uptime Terjamin</p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
}
