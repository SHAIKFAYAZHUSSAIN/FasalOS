import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import {
  TrendingUp,
  Sprout,
  Sun,
  ShieldCheck,
  Scale,
  Users,
  Banknote,
  Repeat,
  HeartHandshake,
  CheckCircle2,
  AlertCircle,
  BarChart3,
  Leaf,
  Layers,
} from 'lucide-react';

export const ImpactPortal: React.FC = () => {
  const { impactMetrics } = useApp();
  const { t } = useTranslation();

  const [impactMode, setImpactMode] = useState<'measured' | 'demo' | 'projected'>('demo');

  // Multipliers for scale projection
  const scaleMultiplier = impactMode === 'projected' ? 10 : 1;

  const farmersServed = impactMetrics.farmersServed * scaleMultiplier;
  const produceHandled = Number((impactMetrics.produceHandledTonnes * scaleMultiplier).toFixed(1));
  const wasteSavedKg = impactMetrics.foodWasteKgRecovered * scaleMultiplier;
  const payoutsInr = impactMetrics.totalFarmerPayoutsInr * scaleMultiplier;

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Header */}
      <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-2xl bg-emerald-100 text-emerald-800 flex items-center justify-center flex-shrink-0">
            <BarChart3 className="w-6 h-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                {t.impact.title}
              </h1>
              <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">
                Evidence-Based Pilot Analytics
              </span>
            </div>
            <p className="text-xs text-[#5C6761] font-medium">
              {t.impact.subtitle}
            </p>
          </div>
        </div>

        {/* 3-Way Mode Switcher: Measured vs Demo vs Projected */}
        <div className="flex items-center bg-[#FAF9F5] p-1 rounded-2xl border border-[#E6E2D8] text-xs font-bold">
          <button
            onClick={() => setImpactMode('measured')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              impactMode === 'measured'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            {t.impact.modeActual}
          </button>
          <button
            onClick={() => setImpactMode('demo')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              impactMode === 'demo'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            {t.impact.modeDemo}
          </button>
          <button
            onClick={() => setImpactMode('projected')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              impactMode === 'projected'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            {t.impact.modeProjected}
          </button>
        </div>
      </div>

      {/* Mode Clarification Banner */}
      <div className="p-3.5 rounded-2xl bg-[#F4F1EA] border border-[#E4DFD3] text-xs flex items-center justify-between gap-3 text-gray-700">
        <div className="flex items-center gap-2">
          <ShieldCheck className="w-4 h-4 text-emerald-700 flex-shrink-0" />
          <span>
            {impactMode === 'measured' && 'Showing verified empirical findings from Kurnool Pilot Hub #04 over 90 harvest cycles.'}
            {impactMode === 'demo' && 'Showing active demo hub state with live simulated produce batches and B2B orders.'}
            {impactMode === 'projected' && 'Showing mathematical projection across 10 linked village micro-hubs in Rayalaseema region.'}
          </span>
        </div>
        <span className="text-[11px] font-bold text-emerald-800 bg-white px-2 py-0.5 rounded border border-gray-200 flex-shrink-0">
          Strict Evidence Standard
        </span>
      </div>

      {/* 4 Core Quantitative Impact Metrics */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
        {/* Metric 1: Loss Avoided */}
        <div className="bg-white rounded-3xl p-5 border border-[#E6E2D8] shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-gray-500 font-semibold">
            <span>{t.impact.lossAvoided}</span>
            <div className="w-7 h-7 rounded-lg bg-emerald-100 text-emerald-800 flex items-center justify-center">
              <Leaf className="w-4 h-4" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#143626] font-heading">
            {impactMetrics.postHarvestLossAvoidedPct}%
          </div>
          <p className="text-[11px] text-gray-500 leading-relaxed">
            {t.impact.lossAvoidedSub}
          </p>
        </div>

        {/* Metric 2: Net Realization Uplift */}
        <div className="bg-white rounded-3xl p-5 border border-[#E6E2D8] shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-gray-500 font-semibold">
            <span>{t.impact.farmerUplift}</span>
            <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center">
              <TrendingUp className="w-4 h-4" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#143626] font-heading">
            +{impactMetrics.farmerNetRealizationUpliftPct}%
          </div>
          <p className="text-[11px] text-gray-500 leading-relaxed">
            {t.impact.farmerUpliftSub}
          </p>
        </div>

        {/* Metric 3: Food Waste Prevented */}
        <div className="bg-white rounded-3xl p-5 border border-[#E6E2D8] shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-gray-500 font-semibold">
            <span>{t.impact.wastePrevented}</span>
            <div className="w-7 h-7 rounded-lg bg-teal-100 text-teal-800 flex items-center justify-center">
              <Sprout className="w-4 h-4" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#143626] font-heading">
            {wasteSavedKg.toLocaleString('en-IN')} <span className="text-sm font-normal text-gray-400">kg</span>
          </div>
          <p className="text-[11px] text-gray-500 leading-relaxed">
            Nutritious produce directed to fresh retail and pulp processing instead of landfill rot.
          </p>
        </div>

        {/* Metric 4: Clean Energy Contribution */}
        <div className="bg-white rounded-3xl p-5 border border-[#E6E2D8] shadow-sm space-y-2">
          <div className="flex items-center justify-between text-xs text-gray-500 font-semibold">
            <span>{t.impact.cleanEnergy}</span>
            <div className="w-7 h-7 rounded-lg bg-amber-100 text-amber-800 flex items-center justify-center">
              <Sun className="w-4 h-4" />
            </div>
          </div>
          <div className="text-3xl font-black text-[#143626] font-heading">
            {impactMetrics.solarEnergyContributionPct}%
          </div>
          <p className="text-[11px] text-gray-500 leading-relaxed">
            Clean decentralized solar micro-cold rooms with zero diesel generator reliance.
          </p>
        </div>
      </div>

      {/* Financial Payouts & Operational Transparency */}
      <div className="grid grid-cols-1 lg:grid-cols-2 gap-6">
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-bold text-base text-[#18221E] font-heading">
              Transparent Smallholder Cash Flow
            </h3>
            <span className="text-xs font-bold text-emerald-800 bg-emerald-50 px-2.5 py-0.5 rounded-full border border-emerald-200">
              100% Direct Bank / UPI
            </span>
          </div>

          <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] space-y-2">
            <div className="flex justify-between text-xs">
              <span className="text-gray-500">{t.impact.directPayouts}:</span>
              <span className="text-base font-black text-[#143626]">
                ₹{payoutsInr.toLocaleString('en-IN')}
              </span>
            </div>
            <div className="flex justify-between text-xs text-gray-500">
              <span>Participating Smallholder Farmers:</span>
              <span className="font-bold text-gray-800">{farmersServed} Farmers</span>
            </div>
            <div className="flex justify-between text-xs text-gray-500">
              <span>Standardized Harvest Handled:</span>
              <span className="font-bold text-gray-800">{produceHandled} Tonnes</span>
            </div>
          </div>

          <p className="text-xs text-gray-600 leading-relaxed">
            FasalOS eliminates middlemen commission layers. Farmers retain 100% visibility of the final B2B contract price, paying only fixed and transparent service and storage rates.
          </p>
        </div>

        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="font-bold text-base text-[#18221E] font-heading">
              Hub Unit Economics & Sustainability
            </h3>
            <span className="text-xs font-bold text-blue-800 bg-blue-50 px-2.5 py-0.5 rounded-full border border-blue-200">
              Self-Sustaining Model
            </span>
          </div>

          <div className="space-y-2.5 text-xs">
            <div className="flex justify-between p-2.5 rounded-xl bg-[#FAF9F5] border border-[#EAE6DD]">
              <span className="text-gray-600">Storage & Pre-cooling Service Fee</span>
              <span className="font-bold text-gray-800">₹0.50 / kg per week</span>
            </div>
            <div className="flex justify-between p-2.5 rounded-xl bg-[#FAF9F5] border border-[#EAE6DD]">
              <span className="text-gray-600">Village Aggregation & Fulfillment Fee</span>
              <span className="font-bold text-gray-800">1.8% of Gross Order Value</span>
            </div>
            <div className="flex justify-between p-2.5 rounded-xl bg-[#FAF9F5] border border-[#EAE6DD]">
              <span className="text-gray-600">Average Hub Payback Period</span>
              <span className="font-bold text-emerald-800">~2.8 Years (Solar Infrastructure)</span>
            </div>
          </div>

          <p className="text-xs text-gray-600 leading-relaxed">
            The village collection center operates as an independent micro-enterprise or Farmer Producer Organization (FPO) business unit.
          </p>
        </div>
      </div>
    </div>
  );
};
