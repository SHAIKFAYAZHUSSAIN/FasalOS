import React from 'react';
import { useApp } from '../../context/AppContext';
import {
  Sparkles,
  ChevronLeft,
  ChevronRight,
  X,
  CheckCircle,
  ArrowRight,
  Sprout,
  Scan,
  QrCode,
  Warehouse,
  LineChart,
  ShoppingBag,
  Layers,
  Truck,
  Banknote,
} from 'lucide-react';

const DEMO_STEPS = [
  {
    step: 1,
    title: 'Farmer Lakshmi Arrives',
    roleTag: 'Farmer Portal',
    desc: 'Lakshmi arrives at Nandikotkur collection center with 250 kg of freshly harvested morning tomatoes.',
    icon: <Sprout className="w-4 h-4 text-emerald-600" />,
  },
  {
    step: 2,
    title: 'Operator Produce Intake',
    roleTag: 'Collection Center',
    desc: 'Operator selects Lakshmi, enters verified scale weight of 250 kg, and logs harvest timestamp.',
    icon: <Scan className="w-4 h-4 text-amber-600" />,
  },
  {
    step: 3,
    title: 'AI Computer Vision Grading',
    roleTag: 'Collection Center',
    desc: 'AI visual scanner assesses ripeness, caliber (55-65mm), defects (<3.5%) -> Suggests Grade A (91% confidence). Operator confirms.',
    icon: <Sparkles className="w-4 h-4 text-emerald-600" />,
  },
  {
    step: 4,
    title: 'Digital Lot & QR Receipt',
    roleTag: 'Collection Center',
    desc: 'Traceable lot LOT-FOS-20481 generated with printable QR receipt, assigned to Solar Cold Room A.',
    icon: <QrCode className="w-4 h-4 text-blue-600" />,
  },
  {
    step: 5,
    title: 'Solar Cold Room Telemetry',
    roleTag: 'Hub Manager',
    desc: 'Produce safely chilled at 8.2°C, 78% humidity. Powered by 74% solar energy with 6h 20m thermal reserve hold.',
    icon: <Warehouse className="w-4 h-4 text-cyan-600" />,
  },
  {
    step: 6,
    title: 'Freshness & FasalOS Copilot',
    roleTag: 'Farmer Portal',
    desc: 'Freshness score is 92/100 (3-5 day window). Copilot compares Local Mandi (₹14/kg) vs Metro B2B (₹18.50 net/kg).',
    icon: <LineChart className="w-4 h-4 text-purple-600" />,
  },
  {
    step: 7,
    title: 'B2B Buyer Requirement',
    roleTag: 'Buyer Marketplace',
    desc: 'Metro Fresh Retail posts high-value demand for 10,000 kg Grade A Tomatoes for Bengaluru supermarket chain.',
    icon: <ShoppingBag className="w-4 h-4 text-indigo-600" />,
  },
  {
    step: 8,
    title: 'Village Smallholder Aggregation',
    roleTag: 'Buyer Marketplace',
    desc: 'FasalOS aggregates Lakshmi (250kg) + Ramesh (1,200kg) + Venkat (600kg) + other farmers into single 10T batch.',
    icon: <Layers className="w-4 h-4 text-amber-600" />,
  },
  {
    step: 9,
    title: 'Cold-Chain Reefer Dispatch',
    roleTag: 'Hub Logistics',
    desc: 'Shipment AP 21 TC 9845 loaded and dispatched with live in-transit temperature tracking (8.5°C).',
    icon: <Truck className="w-4 h-4 text-blue-600" />,
  },
  {
    step: 10,
    title: 'Transparent Farmer Settlement',
    roleTag: 'Farmer Settlement',
    desc: 'Gross ₹44,100 - Storage ₹500 - Transport ₹725 = Net ₹42,875 credited to Lakshmi! Hub impact metrics updated.',
    icon: <Banknote className="w-4 h-4 text-emerald-600" />,
  },
];

export const DemoTourBar: React.FC = () => {
  const { demoActive, demoStep, nextDemoStep, prevDemoStep, jumpToDemoStep, endDemoTour } = useApp();

  if (!demoActive) return null;

  const currentStepData = DEMO_STEPS.find((s) => s.step === demoStep) || DEMO_STEPS[0];

  return (
    <div className="fixed bottom-4 left-1/2 -translate-x-1/2 w-[95%] max-w-4xl z-50 animate-in slide-in-from-bottom-5 duration-300">
      <div className="bg-[#18221E] text-white rounded-2xl shadow-2xl border border-emerald-500/30 p-3 sm:p-4 backdrop-blur-xl">
        {/* Top Header */}
        <div className="flex items-center justify-between gap-2 border-b border-gray-800 pb-2 mb-2">
          <div className="flex items-center gap-2">
            <span className="flex items-center gap-1.5 bg-emerald-900/60 text-emerald-300 text-[11px] font-bold px-2.5 py-0.5 rounded-full border border-emerald-500/40">
              <Sparkles className="w-3 h-3 text-amber-300" />
              3-Minute Guided Demo Flow
            </span>
            <span className="text-xs text-gray-400 font-medium">
              Step {demoStep} of {DEMO_STEPS.length}
            </span>
          </div>

          <button
            onClick={endDemoTour}
            className="text-gray-400 hover:text-white p-1 rounded-lg hover:bg-gray-800 transition-colors"
            title="Exit Demo Tour"
          >
            <X className="w-4 h-4" />
          </button>
        </div>

        {/* Step Content */}
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3">
          <div className="flex items-start gap-3">
            <div className="w-9 h-9 rounded-xl bg-gray-800 flex items-center justify-center flex-shrink-0 mt-0.5 border border-gray-700">
              {currentStepData.icon}
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h4 className="text-sm font-bold text-white font-heading">
                  {currentStepData.step}. {currentStepData.title}
                </h4>
                <span className="text-[10px] font-semibold px-2 py-0.5 rounded bg-emerald-500/20 text-emerald-300 border border-emerald-500/30">
                  {currentStepData.roleTag}
                </span>
              </div>
              <p className="text-xs text-gray-300 mt-0.5 leading-relaxed max-w-xl">
                {currentStepData.desc}
              </p>
            </div>
          </div>

          {/* Stepper Controls */}
          <div className="flex items-center gap-2 self-end sm:self-center flex-shrink-0">
            <button
              onClick={prevDemoStep}
              disabled={demoStep === 1}
              className="flex items-center gap-1 px-2.5 py-1.5 rounded-xl border border-gray-700 bg-gray-800 text-xs font-semibold text-gray-300 hover:bg-gray-700 disabled:opacity-40 disabled:hover:bg-gray-800 transition-colors"
            >
              <ChevronLeft className="w-3.5 h-3.5" />
              <span className="hidden sm:inline">Back</span>
            </button>

            <button
              onClick={nextDemoStep}
              className="flex items-center gap-1 px-3 py-1.5 rounded-xl bg-[#52B788] text-[#143626] text-xs font-bold hover:bg-[#74C69D] transition-all shadow-md shadow-emerald-900/40"
            >
              <span>{demoStep === DEMO_STEPS.length ? 'Finish Demo' : 'Next Step'}</span>
              {demoStep === DEMO_STEPS.length ? (
                <CheckCircle className="w-3.5 h-3.5" />
              ) : (
                <ArrowRight className="w-3.5 h-3.5" />
              )}
            </button>
          </div>
        </div>

        {/* Progress Bar / Dots */}
        <div className="grid grid-cols-10 gap-1.5 mt-3 pt-2 border-t border-gray-800/80">
          {DEMO_STEPS.map((s) => (
            <button
              key={s.step}
              onClick={() => jumpToDemoStep(s.step)}
              className={`h-1.5 rounded-full transition-all ${
                s.step === demoStep
                  ? 'bg-amber-400 ring-2 ring-amber-400/30'
                  : s.step < demoStep
                  ? 'bg-emerald-500'
                  : 'bg-gray-700 hover:bg-gray-600'
              }`}
              title={`${s.step}. ${s.title}`}
            />
          ))}
        </div>
      </div>
    </div>
  );
};
