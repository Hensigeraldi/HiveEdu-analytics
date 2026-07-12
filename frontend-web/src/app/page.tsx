import Navbar from "@/components/landing/Navbar";
import Hero from "@/components/landing/Hero";
import About from "@/components/landing/About";
import Features from "@/components/landing/Features";
import Advantages from "@/components/landing/Advantages";
import CTA from "@/components/landing/CTA";
import Footer from "@/components/landing/Footer";

export default function Home() {
  return (
    <div className="flex flex-col min-h-screen font-sans">
      <Navbar />
      <main className="flex-1">
        <Hero />
        <About />
        <Features />
        <Advantages />
        <CTA />
      </main>
      <Footer />
    </div>
  );
}
