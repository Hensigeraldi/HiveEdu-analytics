import Link from "next/link";
import { ArrowRight } from "lucide-react";

export default function CTA() {
  return (
    <section className="py-24 bg-white dark:bg-black relative overflow-hidden">
      <div className="absolute inset-0 w-full h-full bg-blue-600 [mask-image:radial-gradient(ellipse_at_center,transparent_0%,black_100%)] opacity-5"></div>
      
      <div className="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        <div className="bg-gradient-to-br from-blue-600 to-blue-800 dark:from-blue-700 dark:to-blue-950 rounded-3xl p-10 md:p-16 text-center shadow-2xl overflow-hidden relative">
          
          <div className="absolute top-0 right-0 w-64 h-64 bg-white/10 rounded-full blur-3xl -translate-y-1/2 translate-x-1/3"></div>
          <div className="absolute bottom-0 left-0 w-64 h-64 bg-cyan-400/20 rounded-full blur-3xl translate-y-1/2 -translate-x-1/3"></div>

          <h2 className="text-3xl md:text-5xl font-bold text-white mb-6 relative z-10">
            Siap Memajukan Sekolah Anda?
          </h2>
          <p className="text-blue-100 text-lg md:text-xl mb-10 max-w-2xl mx-auto relative z-10">
            Bergabunglah dengan ratusan sekolah lain yang telah merasakan kemudahan sistem kami.
          </p>
          
          <div className="flex flex-col sm:flex-row gap-4 justify-center relative z-10">
            <Link
              href="/login"
              className="inline-flex items-center justify-center gap-2 px-8 py-4 text-base font-semibold text-blue-600 bg-white hover:bg-zinc-50 rounded-full shadow-lg transition-all hover:scale-105"
            >
              Coba Sekarang
              <ArrowRight size={20} />
            </Link>
          </div>
        </div>
      </div>
    </section>
  );
}
