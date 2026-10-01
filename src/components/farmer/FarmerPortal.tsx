import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import {
  Sprout,
  TrendingUp,
  Clock,
  Sparkles,
  PhoneCall,
  MessageCircle,
  QrCode,
  ShieldCheck,
  ChevronRight,
  ArrowRight,
  CheckCircle2,
  Calendar,
  AlertCircle,
  HelpCircle,
  Info,
  Banknote,
  Receipt,
  FileText,
  User,
  Home,
  Layers,
} from 'lucide-react';

export const FarmerPortal: React.FC = () => {
  const {
    activeTab,
    setActiveTab,
    lots,
    settlement,
    openCopilotForLot,
    openReceiptForLot,
    setCurrentRole,
  } = useApp();
  const { t } = useTranslation();

  const [callModalOpen, setCallModalOpen] = useState(false);
  const [logProduceModalOpen, setLogProduceModalOpen] = useState(false);

  // Lakshmi's primary active lot
  const lakshmiLot = lots.find((l) => l.farmerName.includes('Lakshmi')) || lots[0];

  return (
    <div className="max-w-md mx-auto min-h-screen bg-[#FAF9F5] pb-24 border-x border-[#E6E2D8] shadow-sm">
      {/* Farmer Greeting Header */}
      <div className="bg-gradient-to-b from-[#D8F3DC]/70 to-[#FAF9F5] p-5 pt-6 border-b border-[#E6E2D8]">
        <div className="flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-12 h-12 rounded-full overflow-hidden border-2 border-[#2D6A4F] shadow-sm flex-shrink-0">
              <img
                src="https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=160&auto=format&fit=crop&q=80"
                alt="Lakshmi Devi"
                className="w-full h-full object-cover"
              />
            </div>
            <div>
              <h1 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                {t.farmer.lakshmiGreeting}
              </h1>
              <p className="text-xs text-[#5C6761] font-medium">{t.farmer.villageTag}</p>
            </div>
          </div>
        </div>

        {/* PRIMARY CTA: "I HAVE PRODUCE TO SELL" */}
        <div className="mt-5">
          <button
            onClick={() => {
              // Directs to operator intake or quick intake request
              setCurrentRole('operator');
              setActiveTab('intake');
            }}
            className="w-full p-4 rounded-2xl bg-[#1B4332] text-white shadow-lg shadow-[#1B4332]/25 hover:bg-[#2D6A4F] active:scale-[0.98] transition-all flex items-center justify-between text-left group"
          >
            <div className="flex items-center gap-3.5">
              <div className="w-11 h-11 rounded-xl bg-amber-400 text-amber-950 flex items-center justify-center font-bold shadow-sm">
                <Sprout className="w-6 h-6" />
              </div>
              <div>
                <h2 className="text-lg font-black text-white font-heading tracking-tight">
                  {t.farmer.primaryAction}
                </h2>
                <p className="text-xs text-emerald-100 font-medium">
                  {t.farmer.primaryActionSub}
                </p>
              </div>
            </div>
            <ArrowRight className="w-5 h-5 text-amber-300 group-hover:translate-x-1 transition-transform" />
          </button>
        </div>
      </div>

      {/* Main Tab Content */}
      <div className="p-4 space-y-4">
        {/* ACTIVE SECTION 1: YOUR PRODUCE IN STORAGE */}
        <div className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-xs space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-[#5C6761] flex items-center gap-1.5">
              <Sprout className="w-3.5 h-3.5 text-emerald-700" />
              {t.farmer.yourProduce}
            </span>
            <span className="text-[11px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">
              Grade {lakshmiLot.grade} Verified
            </span>
          </div>

          <div className="flex items-center justify-between pt-1">
            <div>
              <h3 className="text-2xl font-black text-[#143626] font-heading">
                {lakshmiLot.cropName}
              </h3>
              <p className="text-xs text-gray-500 font-medium">
                {lakshmiLot.quantityKg} kg · {lakshmiLot.variety} · {lakshmiLot.storageSlot}
              </p>
            </div>
            <div className="text-right">
              <div className="text-[10px] text-gray-400 uppercase font-bold">{t.farmer.freshness}</div>
              <div className="text-xl font-black text-emerald-700 font-heading">
                {lakshmiLot.freshnessScore}<span className="text-xs font-normal text-gray-400">/100</span>
              </div>
            </div>
          </div>

          {/* Freshness Progress Bar */}
          <div className="space-y-1">
            <div className="flex justify-between text-[11px] font-medium text-gray-500">
              <span>{t.farmer.commercialWindow}: <strong className="text-amber-700">~{Math.round(lakshmiLot.commercialShelfLifeHours / 24)} {t.farmer.freshnessDaysRemaining}</strong></span>
              <span className="text-emerald-700 font-semibold">{t.farmer.statusAvailable}</span>
            </div>
            <div className="w-full h-2 rounded-full bg-gray-100 overflow-hidden">
              <div
                className="h-full bg-gradient-to-r from-emerald-500 to-emerald-600 rounded-full"
                style={{ width: `${lakshmiLot.freshnessScore}%` }}
              />
            </div>
          </div>

          {/* Receipt CTA */}
          <button
            onClick={() => openReceiptForLot(lakshmiLot)}
            className="w-full mt-2 py-2 px-3 rounded-xl border border-[#E6E2D8] bg-[#FAF9F5] text-xs font-bold text-[#18221E] hover:bg-[#F2EFE9] transition-colors flex items-center justify-center gap-1.5"
          >
            <QrCode className="w-3.5 h-3.5 text-emerald-700" />
            <span>{t.farmer.viewReceipt}</span>
          </button>
        </div>

        {/* ACTIVE SECTION 2: TODAY'S OPPORTUNITY (COPILOT) */}
        <div className="p-4 rounded-2xl bg-gradient-to-br from-amber-50/70 via-emerald-50/40 to-white border border-amber-200/80 shadow-xs space-y-2.5">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-amber-900 flex items-center gap-1.5">
              <Sparkles className="w-3.5 h-3.5 text-amber-600" />
              {t.farmer.todayOpportunity}
            </span>
            <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-200 text-amber-900">
              FasalOS Copilot
            </span>
          </div>

          <p className="text-xs sm:text-sm font-semibold text-[#18221E] leading-relaxed">
            {t.farmer.opportunityFound}
          </p>

          <div className="p-2.5 rounded-xl bg-white/90 border border-amber-200 text-xs flex items-center justify-between">
            <div>
              <span className="text-[10px] text-gray-500 uppercase">Suggested Market</span>
              <div className="font-bold text-[#1B4332]">Bengaluru B2B Retail Depot</div>
            </div>
            <div className="text-right">
              <span className="text-[10px] text-gray-500 uppercase">Expected Net</span>
              <div className="font-black text-emerald-700 text-sm">₹18.50 / kg</div>
            </div>
          </div>

          <button
            onClick={() => openCopilotForLot(lakshmiLot)}
            className="w-full py-2.5 px-4 rounded-xl bg-[#2D6A4F] text-white text-xs font-bold hover:bg-[#1B4332] transition-colors flex items-center justify-center gap-1.5 shadow-xs"
          >
            <span>{t.farmer.viewOptions}</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>

        {/* ACTIVE SECTION 3: YOUR EARNINGS & SETTLEMENT */}
        <div className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-xs space-y-3">
          <div className="flex items-center justify-between">
            <span className="text-xs font-bold uppercase tracking-wider text-[#5C6761] flex items-center gap-1.5">
              <Banknote className="w-3.5 h-3.5 text-emerald-700" />
              {t.farmer.yourEarnings}
            </span>
            <span className="text-[10px] font-semibold text-gray-400">{t.farmer.thisMonth}</span>
          </div>

          <div>
            <div className="text-3xl font-black text-[#143626] font-heading">
              ₹42,875
            </div>
            <div className="flex items-center gap-1.5 text-xs text-emerald-700 font-semibold mt-1">
              <CheckCircle2 className="w-3.5 h-3.5" />
              <span>Transferred via UPI · Ref: UPI/2026/FOS-88910</span>
            </div>
          </div>

          {/* Itemized Transparent Breakdown */}
          <div className="p-3 bg-[#FAF9F5] rounded-xl border border-[#EAE6DD] text-xs space-y-1.5">
            <div className="flex justify-between text-gray-600">
              <span>Gross produce (2,450 kg @ ₹18/kg)</span>
              <span className="font-semibold text-gray-800">₹44,100</span>
            </div>
            <div className="flex justify-between text-gray-600">
              <span>Solar micro-cold storage fee</span>
              <span className="text-amber-700 font-semibold">-₹500</span>
            </div>
            <div className="flex justify-between text-gray-600">
              <span>Aggregated reefer transport</span>
              <span className="text-amber-700 font-semibold">-₹725</span>
            </div>
            <div className="pt-1.5 border-t border-[#E0DCD2] flex justify-between font-bold text-[#18221E]">
              <span>Net settlement received</span>
              <span className="text-emerald-800 text-sm">₹42,875</span>
            </div>
          </div>

          <div className="text-[11px] text-gray-500 font-medium">
            Estimated avoided post-harvest loss: <strong className="text-emerald-800">₹8,400</strong>
          </div>
        </div>

        {/* ACTIVE SECTION 4: NEED HELP / OPERATOR CONTACT */}
        <div className="p-4 rounded-2xl bg-white border border-[#E6E2D8] shadow-xs">
          <h4 className="text-xs font-bold uppercase tracking-wider text-[#5C6761] mb-2 flex items-center gap-1.5">
            <HelpCircle className="w-3.5 h-3.5 text-gray-400" />
            {t.farmer.needHelp}
          </h4>

          <div className="grid grid-cols-2 gap-2 mt-2">
            <button
              onClick={() => setCallModalOpen(true)}
              className="p-3 rounded-xl border border-emerald-300 bg-emerald-50/70 text-emerald-900 text-xs font-bold hover:bg-emerald-100 transition-colors flex items-center justify-center gap-2"
            >
              <PhoneCall className="w-4 h-4 text-emerald-700" />
              <span>Call Operator</span>
            </button>

            <button
              onClick={() => {
                window.open('https://wa.me/?text=Namaskaram%2C%20I%20have%20fresh%20produce%20to%20store%20at%20FasalOS%20Nandikotkur%20Hub.', '_blank');
              }}
              className="p-3 rounded-xl border border-emerald-300 bg-emerald-50/70 text-emerald-900 text-xs font-bold hover:bg-emerald-100 transition-colors flex items-center justify-center gap-2"
            >
              <MessageCircle className="w-4 h-4 text-emerald-700" />
              <span>WhatsApp</span>
            </button>
          </div>
        </div>
      </div>

      {/* Operator Call Modal Dialog */}
      {callModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-black/60 backdrop-blur-xs">
          <div className="bg-white rounded-3xl p-6 max-w-sm w-full text-center space-y-4 border border-[#E6E2D8] shadow-xl">
            <div className="w-14 h-14 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center mx-auto">
              <PhoneCall className="w-7 h-7" />
            </div>
            <div>
              <h4 className="text-lg font-bold text-[#18221E] font-heading">
                FasalOS Center Operator
              </h4>
              <p className="text-xs text-gray-500 mt-0.5">
                Nandikotkur Village Collection Hub #04
              </p>
              <p className="text-lg font-mono font-bold text-emerald-800 mt-2">
                +91 98490 12345
              </p>
            </div>
            <p className="text-xs text-gray-600">
              The operator can assist you with weighing, transport crates, and immediate cold storage intake.
            </p>
            <div className="flex gap-2">
              <button
                onClick={() => setCallModalOpen(false)}
                className="flex-1 py-2.5 rounded-xl border border-gray-300 text-xs font-semibold text-gray-700"
              >
                Close
              </button>
              <a
                href="tel:+919849012345"
                className="flex-1 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold flex items-center justify-center gap-1.5"
              >
                Call Now
              </a>
            </div>
          </div>
        </div>
      )}

      {/* Mobile Bottom Navigation for Farmer */}
      <div className="fixed bottom-0 left-0 right-0 max-w-md mx-auto bg-white/95 backdrop-blur-md border-t border-[#E6E2D8] px-4 py-2 flex items-center justify-around z-30">
        <button
          onClick={() => setActiveTab('home')}
          className={`flex flex-col items-center gap-1 text-[11px] font-semibold transition-colors ${
            activeTab === 'home' ? 'text-[#1B4332]' : 'text-gray-400'
          }`}
        >
          <Home className="w-5 h-5" />
          <span>Home</span>
        </button>

        <button
          onClick={() => openReceiptForLot(lakshmiLot)}
          className={`flex flex-col items-center gap-1 text-[11px] font-semibold transition-colors ${
            activeTab === 'produce' ? 'text-[#1B4332]' : 'text-gray-400'
          }`}
        >
          <Receipt className="w-5 h-5" />
          <span>Receipt</span>
        </button>

        <button
          onClick={() => openCopilotForLot(lakshmiLot)}
          className={`flex flex-col items-center gap-1 text-[11px] font-semibold transition-colors ${
            activeTab === 'market' ? 'text-[#1B4332]' : 'text-gray-400'
          }`}
        >
          <Sparkles className="w-5 h-5" />
          <span>Copilot</span>
        </button>

        <button
          onClick={() => setActiveTab('earnings')}
          className={`flex flex-col items-center gap-1 text-[11px] font-semibold transition-colors ${
            activeTab === 'earnings' ? 'text-[#1B4332]' : 'text-gray-400'
          }`}
        >
          <Banknote className="w-5 h-5" />
          <span>Earnings</span>
        </button>
      </div>
    </div>
  );
};
