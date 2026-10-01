import React from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import {
  Sprout,
  Store,
  Warehouse,
  ShoppingBag,
  Sparkles,
  Sun,
  ShieldCheck,
  TrendingUp,
  ArrowRight,
  Layers,
  Clock,
  Scan,
  CheckCircle2,
  Truck,
  Banknote,
  Repeat,
  HeartHandshake,
  BarChart3,
  Cpu,
} from 'lucide-react';

export const LandingPage: React.FC = () => {
  const { setCurrentRole, setActiveTab, startDemoTour } = useApp();
  const { t } = useTranslation();

  const journeySteps = [
    { num: '01', title: 'Harvest', desc: 'Farmers harvest at peak maturity in early morning chill.', icon: <Sprout className="w-5 h-5 text-emerald-600" /> },
    { num: '02', title: 'Grade', desc: 'AI computer vision evaluates ripeness, caliber, and defects.', icon: <Scan className="w-5 h-5 text-amber-600" /> },
    { num: '03', title: 'Store', desc: 'Pre-cooled in solar micro-cold rooms with thermal reserve.', icon: <Warehouse className="w-5 h-5 text-blue-600" /> },
    { num: '04', title: 'Understand', desc: 'Dynamic shelf-life engine & Copilot compare selling options.', icon: <Cpu className="w-5 h-5 text-purple-600" /> },
    { num: '05', title: 'Aggregate', desc: 'Multi-smallholder lots united into verified commercial batches.', icon: <Layers className="w-5 h-5 text-indigo-600" /> },
    { num: '06', title: 'Sell', desc: 'Direct matching with high-realization B2B buyers and retail.', icon: <ShoppingBag className="w-5 h-5 text-emerald-700" /> },
    { num: '07', title: 'Settle', desc: 'Transparent itemized payout credited directly within 24 hours.', icon: <Banknote className="w-5 h-5 text-amber-700" /> },
  ];

  const flywheelStages = [
    'Farmers',
    'Collection',
    'Quality Data',
    'Digital Lots',
    'Storage',
    'Freshness Data',
    'Market Intelligence',
    'Buyer Matching',
    'Aggregation',
    'Logistics',
    'Sale',
    'Settlement',
    'Ecosystem Data',
  ];

  return (
    <div className="min-h-screen bg-[#FAF9F5] text-[#18221E] selection:bg-[#52B788] selection:text-white">
      {/* Hero Section */}
      <section className="relative overflow-hidden pt-8 pb-16 sm:pt-14 sm:pb-24 border-b border-[#E6E2D8]">
        {/* Subtle background agricultural motifs */}
        <div className="absolute top-0 right-0 -mr-20 -mt-20 w-96 h-96 rounded-full bg-gradient-to-br from-[#D8F3DC]/40 to-transparent blur-3xl pointer-events-none" />
        <div className="absolute bottom-0 left-0 -ml-20 -mb-20 w-96 h-96 rounded-full bg-gradient-to-tr from-amber-100/40 to-transparent blur-3xl pointer-events-none" />

        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
          <div className="text-center max-w-3xl mx-auto space-y-4">
            {/* Tagline Badge */}
            <div className="inline-flex items-center gap-2 px-3 py-1 rounded-full bg-[#EAE6DC] border border-[#DDD8CD] text-xs font-bold text-[#1B4332] shadow-xs">
              <Sun className="w-3.5 h-3.5 text-amber-600" />
              <span>The Operating System for Post-Harvest Agriculture</span>
            </div>

            {/* Main Headline */}
            <h1 className="text-4xl sm:text-6xl font-black text-[#143626] tracking-tight leading-[1.1] font-heading">
              From harvest to the <span className="text-[#2D6A4F] underline decoration-[#F59E0B] decoration-4 underline-offset-4">right market.</span>
            </h1>

            {/* Subtitle */}
            <p className="text-base sm:text-xl text-[#5C6761] leading-relaxed max-w-2xl mx-auto font-medium">
              FasalOS turns a farmer's harvest into intelligent, traceable, market-ready inventory — combining solar micro-cold rooms, computer-vision grading, and direct B2B aggregation.
            </p>

            {/* Primary Action Buttons */}
            <div className="flex flex-wrap items-center justify-center gap-3 pt-3">
              <button
                onClick={startDemoTour}
                className="flex items-center gap-2 px-6 py-3.5 rounded-2xl bg-[#1B4332] text-white font-bold text-sm hover:bg-[#2D6A4F] transition-all shadow-lg shadow-[#1B4332]/25 hover:shadow-xl hover:-translate-y-0.5"
              >
                <Sparkles className="w-4 h-4 text-amber-300" />
                <span>Launch 3-Minute Interactive Demo</span>
                <ArrowRight className="w-4 h-4" />
              </button>

              <button
                onClick={() => {
                  setCurrentRole('farmer');
                  setActiveTab('home');
                }}
                className="flex items-center gap-2 px-6 py-3.5 rounded-2xl bg-white border border-[#D5D0C3] text-[#18221E] font-bold text-sm hover:bg-[#F2EFE9] transition-all shadow-sm"
              >
                <Sprout className="w-4 h-4 text-emerald-700" />
                <span>Explore Farmer Experience</span>
              </button>
            </div>

            <div className="pt-2 text-xs text-[#7A8780] font-medium flex items-center justify-center gap-4">
              <span>✓ Solar Micro-Cold Storage</span>
              <span>•</span>
              <span>✓ AI Computer Vision Grading</span>
              <span>•</span>
              <span>✓ Village Aggregation</span>
            </div>
          </div>

          {/* Interactive Hero Scene Preview Card */}
          <div className="mt-12 max-w-5xl mx-auto rounded-3xl bg-white border border-[#E6E2D8] shadow-xl overflow-hidden">
            <div className="bg-[#18221E] text-white px-5 py-3 flex items-center justify-between text-xs">
              <div className="flex items-center gap-2">
                <span className="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse" />
                <span className="font-bold">Live Hub Telemetry: Kurnool Demo Hub #04</span>
                <span className="text-gray-400 hidden sm:inline">· Nandikotkur, AP</span>
              </div>
              <div className="flex items-center gap-4 text-gray-300">
                <span>Solar: <strong className="text-amber-300">74%</strong></span>
                <span>Cold Room: <strong className="text-emerald-300">8.2°C</strong></span>
                <span>Thermal Reserve: <strong className="text-cyan-300">6h 20m</strong></span>
              </div>
            </div>

            <div className="p-6 grid grid-cols-1 md:grid-cols-3 gap-6 bg-[#FAF9F5]/50">
              {/* Box 1: Farmer & Intake */}
              <div
                onClick={() => {
                  setCurrentRole('farmer');
                  setActiveTab('home');
                }}
                className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-sm hover:border-emerald-500 cursor-pointer transition-all hover:shadow-md"
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-[11px] font-bold uppercase tracking-wider text-emerald-700 bg-emerald-50 px-2 py-0.5 rounded">
                    Farmer Portal
                  </span>
                  <Sprout className="w-4 h-4 text-emerald-600" />
                </div>
                <h4 className="text-base font-bold text-[#18221E]">Lakshmi's Produce</h4>
                <p className="text-xs text-gray-600 mt-1">
                  250 kg Fresh Tomatoes · Freshness 92/100 · Optimal window: 3–5 days.
                </p>
                <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between text-xs text-emerald-800 font-bold">
                  <span>View Selling Options</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </div>
              </div>

              {/* Box 2: AI Copilot & Market Options */}
              <div
                onClick={() => {
                  setCurrentRole('farmer');
                  setActiveTab('produce');
                }}
                className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-sm hover:border-amber-500 cursor-pointer transition-all hover:shadow-md"
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-[11px] font-bold uppercase tracking-wider text-amber-800 bg-amber-50 px-2 py-0.5 rounded">
                    FasalOS Copilot
                  </span>
                  <Sparkles className="w-4 h-4 text-amber-600" />
                </div>
                <h4 className="text-base font-bold text-[#18221E]">Market Intelligence</h4>
                <p className="text-xs text-gray-600 mt-1">
                  Metro B2B Depot indicates expected net realization of <strong className="text-emerald-800">₹18.50/kg</strong> vs ₹14 local mandi.
                </p>
                <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between text-xs text-amber-800 font-bold">
                  <span>Explore 3 Markets</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </div>
              </div>

              {/* Box 3: B2B Aggregation */}
              <div
                onClick={() => {
                  setCurrentRole('buyer');
                  setActiveTab('aggregate');
                }}
                className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-sm hover:border-blue-500 cursor-pointer transition-all hover:shadow-md"
              >
                <div className="flex items-center justify-between mb-3">
                  <span className="text-[11px] font-bold uppercase tracking-wider text-blue-800 bg-blue-50 px-2 py-0.5 rounded">
                    Village Aggregation
                  </span>
                  <Layers className="w-4 h-4 text-blue-600" />
                </div>
                <h4 className="text-base font-bold text-[#18221E]">10-Tonne Buyer Match</h4>
                <p className="text-xs text-gray-600 mt-1">
                  Aggregating Lakshmi (250kg), Ramesh (1,200kg), Venkat (600kg) for Metro Fresh order.
                </p>
                <div className="mt-3 pt-3 border-t border-gray-100 flex items-center justify-between text-xs text-blue-800 font-bold">
                  <span>View Aggregation</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </div>
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* 7-Step Story Section */}
      <section className="py-16 bg-white border-b border-[#E6E2D8]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-12">
            <span className="text-xs font-bold uppercase tracking-widest text-[#2D6A4F]">
              The Post-Harvest Architecture
            </span>
            <h2 className="text-3xl sm:text-4xl font-black text-[#143626] font-heading mt-1">
              7 Steps from Farm to the Right Market
            </h2>
            <p className="text-sm text-gray-600 mt-2">
              Transforming individual distress sales into standardized, cold-chain preserved, market-ready inventory.
            </p>
          </div>

          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-7 gap-4">
            {journeySteps.map((step) => (
              <div
                key={step.num}
                className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-emerald-500 hover:bg-emerald-50/20 transition-all flex flex-col justify-between"
              >
                <div>
                  <div className="flex items-center justify-between mb-3">
                    <span className="text-xs font-mono font-black text-gray-400">{step.num}</span>
                    <div className="p-1.5 rounded-lg bg-white border border-[#E6E2D8] shadow-xs">
                      {step.icon}
                    </div>
                  </div>
                  <h3 className="font-bold text-sm text-[#18221E] font-heading">{step.title}</h3>
                  <p className="text-xs text-gray-600 mt-1.5 leading-relaxed">{step.desc}</p>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>

      {/* The Core FasalOS Flywheel */}
      <section className="py-16 bg-[#FAF9F5] border-b border-[#E6E2D8]">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-10">
            <span className="text-xs font-bold uppercase tracking-widest text-[#D97706] flex items-center justify-center gap-1.5">
              <Repeat className="w-3.5 h-3.5" />
              Network Effects
            </span>
            <h2 className="text-3xl sm:text-4xl font-black text-[#143626] font-heading mt-1">
              The FasalOS Flywheel
            </h2>
            <p className="text-sm text-gray-600 mt-2">
              Each harvested crate creates traceability, freshness data, and pricing intelligence that attracts more buyers and higher realization for farmers.
            </p>
          </div>

          {/* Interactive Flywheel Track */}
          <div className="p-6 rounded-3xl bg-white border border-[#E6E2D8] shadow-sm max-w-4xl mx-auto">
            <div className="flex flex-wrap items-center justify-center gap-2">
              {flywheelStages.map((stage, idx) => (
                <React.Fragment key={idx}>
                  <div className="px-3 py-1.5 rounded-xl bg-[#FAF9F5] border border-[#E0DCD2] text-xs font-bold text-[#1B4332] shadow-xs hover:bg-[#D8F3DC] transition-colors">
                    {stage}
                  </div>
                  {idx < flywheelStages.length - 1 && (
                    <ArrowRight className="w-3.5 h-3.5 text-gray-400" />
                  )}
                </React.Fragment>
              ))}
            </div>
            <div className="mt-4 pt-4 border-t border-gray-100 text-center text-xs text-emerald-800 font-semibold flex items-center justify-center gap-1.5">
              <Sparkles className="w-4 h-4 text-amber-500" />
              <span>More Data → Better Intelligence → Higher Net Realization → More Farming Villages</span>
            </div>
          </div>
        </div>
      </section>

      {/* Role Launchpad Cards */}
      <section className="py-16 bg-white">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center max-w-2xl mx-auto mb-12">
            <h2 className="text-3xl sm:text-4xl font-black text-[#143626] font-heading">
              Select Your Role in the Network
            </h2>
            <p className="text-sm text-gray-600 mt-2">
              Experience the dedicated workflows built for each agricultural stakeholder.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
            {/* Farmer Card */}
            <div
              onClick={() => {
                setCurrentRole('farmer');
                setActiveTab('home');
              }}
              className="p-6 rounded-3xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-emerald-500 hover:shadow-lg transition-all cursor-pointer group flex flex-col justify-between"
            >
              <div>
                <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-800 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Sprout className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">Farmer</h3>
                <p className="text-xs text-gray-600 mt-2 leading-relaxed">
                  Log harvests, track cold storage freshness, receive digital lot receipts, and view FasalOS Copilot selling opportunities.
                </p>
              </div>
              <div className="mt-6 pt-4 border-t border-gray-200 flex items-center justify-between text-xs font-bold text-emerald-800">
                <span>Enter Farmer Portal</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </div>
            </div>

            {/* Operator Card */}
            <div
              onClick={() => {
                setCurrentRole('operator');
                setActiveTab('intake');
              }}
              className="p-6 rounded-3xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-amber-500 hover:shadow-lg transition-all cursor-pointer group flex flex-col justify-between"
            >
              <div>
                <div className="w-12 h-12 rounded-2xl bg-amber-100 text-amber-800 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Store className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">Collection Operator</h3>
                <p className="text-xs text-gray-600 mt-2 leading-relaxed">
                  10-step guided intake wizard, computer vision grading with confidence score, digital lot issuance, and offline sync.
                </p>
              </div>
              <div className="mt-6 pt-4 border-t border-gray-200 flex items-center justify-between text-xs font-bold text-amber-800">
                <span>Enter Operator Portal</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </div>
            </div>

            {/* Hub Manager Card */}
            <div
              onClick={() => {
                setCurrentRole('hub');
                setActiveTab('coldroom');
              }}
              className="p-6 rounded-3xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-blue-500 hover:shadow-lg transition-all cursor-pointer group flex flex-col justify-between"
            >
              <div>
                <div className="w-12 h-12 rounded-2xl bg-blue-100 text-blue-800 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <Warehouse className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">Hub Manager</h3>
                <p className="text-xs text-gray-600 mt-2 leading-relaxed">
                  Real-time cold-room telemetry, 74% solar generation monitor, thermal reserve hold, at-risk inventory watchlist, and logistics.
                </p>
              </div>
              <div className="mt-6 pt-4 border-t border-gray-200 flex items-center justify-between text-xs font-bold text-blue-800">
                <span>Enter Hub Dashboard</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </div>
            </div>

            {/* Buyer Card */}
            <div
              onClick={() => {
                setCurrentRole('buyer');
                setActiveTab('marketplace');
              }}
              className="p-6 rounded-3xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-purple-500 hover:shadow-lg transition-all cursor-pointer group flex flex-col justify-between"
            >
              <div>
                <div className="w-12 h-12 rounded-2xl bg-purple-100 text-purple-800 flex items-center justify-center mb-4 group-hover:scale-110 transition-transform">
                  <ShoppingBag className="w-6 h-6" />
                </div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">B2B Buyer</h3>
                <p className="text-xs text-gray-600 mt-2 leading-relaxed">
                  Source verified, cold-chain preserved produce. View multi-farmer aggregation engine matching smallholders to bulk commercial orders.
                </p>
              </div>
              <div className="mt-6 pt-4 border-t border-gray-200 flex items-center justify-between text-xs font-bold text-purple-800">
                <span>Enter Marketplace</span>
                <ArrowRight className="w-4 h-4 group-hover:translate-x-1 transition-transform" />
              </div>
            </div>
          </div>
        </div>
      </section>

      {/* Footer */}
      <footer className="border-t border-[#E6E2D8] bg-[#FAF9F5] py-8 text-xs text-[#5C6761]">
        <div className="max-w-7xl mx-auto px-4 flex flex-col sm:flex-row items-center justify-between gap-4">
          <div className="flex items-center gap-2">
            <span className="font-bold text-[#18221E]">FasalOS</span>
            <span>·</span>
            <span>The Operating System for Post-Harvest Agriculture</span>
          </div>
          <div>
            Kurnool Pilot Hub #04 · Andhra Pradesh · Multilingual Edition (EN, TE, HI, TA, KN)
          </div>
        </div>
      </footer>
    </div>
  );
};
