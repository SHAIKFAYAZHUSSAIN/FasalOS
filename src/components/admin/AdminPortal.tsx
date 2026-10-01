import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import {
  ShieldCheck,
  Settings,
  Cpu,
  Sliders,
  DollarSign,
  Warehouse,
  Save,
  CheckCircle2,
  FileText,
  AlertCircle,
  Database,
  Lock,
} from 'lucide-react';

export const AdminPortal: React.FC = () => {
  const { crops, coldRooms } = useApp();
  const { t } = useTranslation();

  const [activeAdminTab, setActiveAdminTab] = useState<'rules' | 'pricing' | 'ai' | 'audit'>('rules');

  // Configurable parameters
  const [storageFeePerKg, setStorageFeePerKg] = useState<number>(0.5);
  const [aggregationMarginPct, setAggregationMarginPct] = useState<number>(2.0);
  const [aiConfidenceThreshold, setAiConfidenceThreshold] = useState<number>(85);
  const [transportCostPerKm, setTransportCostPerKm] = useState<number>(18.0);
  const [savedToast, setSavedToast] = useState<boolean>(false);

  const handleSaveConfig = () => {
    setSavedToast(true);
    setTimeout(() => setSavedToast(false), 2500);
  };

  const auditLogs = [
    { time: '10:45 AM', user: 'Operator (Kurnool #04)', action: 'Lot LOT-FOS-20481 created (250 kg Grade A Tomatoes)' },
    { time: '09:30 AM', user: 'AI Copilot Engine', action: 'Market price refresh from Hyderabad & Bengaluru depots' },
    { time: '08:15 AM', user: 'IoT Telemetry Gateway', action: 'Cold Room A temperature verified at 8.2°C (Solar 74%)' },
    { time: 'Yesterday', user: 'Financial Settlement API', action: 'Disbursed ₹42,875 to Lakshmi Devi (Ref: UPI-88910)' },
  ];

  return (
    <div className="max-w-6xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-2xl bg-slate-100 text-slate-800 flex items-center justify-center flex-shrink-0">
            <ShieldCheck className="w-6 h-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                {t.nav.admin}
              </h1>
              <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-slate-100 text-slate-800">
                Configuration & Governance
              </span>
            </div>
            <p className="text-xs text-[#5C6761] font-medium">
              FasalOS Core Architecture Settings · Kurnool Hub Node #04
            </p>
          </div>
        </div>

        {/* Tab Switcher */}
        <div className="flex items-center bg-[#FAF9F5] p-1 rounded-2xl border border-[#E6E2D8] text-xs font-bold">
          <button
            onClick={() => setActiveAdminTab('rules')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              activeAdminTab === 'rules'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Crop & Shelf Rules
          </button>
          <button
            onClick={() => setActiveAdminTab('pricing')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              activeAdminTab === 'pricing'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Pricing & Fee Model
          </button>
          <button
            onClick={() => setActiveAdminTab('ai')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              activeAdminTab === 'ai'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            AI Engine Tuning
          </button>
          <button
            onClick={() => setActiveAdminTab('audit')}
            className={`px-3 py-1.5 rounded-xl transition-all ${
              activeAdminTab === 'audit'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Audit Logs
          </button>
        </div>
      </div>

      {savedToast && (
        <div className="p-3 bg-emerald-100 border border-emerald-300 text-emerald-900 rounded-2xl text-xs font-bold flex items-center gap-2 animate-in fade-in">
          <CheckCircle2 className="w-4 h-4 text-emerald-700" />
          <span>Configuration parameters updated and broadcasted to edge collection nodes.</span>
        </div>
      )}

      {/* TAB 1: CROP & SHELF-LIFE RULES */}
      {activeAdminTab === 'rules' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6">
          <div>
            <h3 className="text-base font-bold text-[#18221E] font-heading">
              Crop Storage & Decay Parameters
            </h3>
            <p className="text-xs text-gray-500">
              Configurable biochemical decay baselines used by Dynamic Shelf-Life Engine.
            </p>
          </div>

          <div className="space-y-3">
            {crops.map((crop) => (
              <div
                key={crop.id}
                className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] grid grid-cols-1 sm:grid-cols-4 gap-4 text-xs items-center"
              >
                <div>
                  <h4 className="font-bold text-sm text-[#18221E]">{crop.name}</h4>
                  <p className="text-gray-500">{crop.category} · {crop.varieties.join(', ')}</p>
                </div>

                <div>
                  <span className="text-gray-500">Ideal Temp:</span>
                  <div className="font-bold text-emerald-800">{crop.optimalTempC.min}°C – {crop.optimalTempC.max}°C</div>
                  <span className="text-gray-500">Humidity:</span> {crop.optimalHumidityPct.min}%–{crop.optimalHumidityPct.max}%
                </div>

                <div>
                  <span className="text-gray-500">Baseline Cold Shelf-Life:</span>
                  <div className="font-bold text-[#18221E]">{crop.baselineColdStorageShelfLifeDays} Days</div>
                  <span className="text-gray-400">vs {crop.baselineAmbientShelfLifeDays} days ambient</span>
                </div>

                <div className="text-right">
                  <button className="px-3 py-1.5 rounded-xl border border-gray-300 bg-white text-xs font-semibold hover:bg-gray-50">
                    Edit Parameters
                  </button>
                </div>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* TAB 2: PRICING & FEE MODEL */}
      {activeAdminTab === 'pricing' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6 max-w-2xl">
          <div>
            <h3 className="text-base font-bold text-[#18221E] font-heading">
              Business Model & Revenue Rules
            </h3>
            <p className="text-xs text-gray-500">
              Rules determine transparent deductions and hub operational revenue streams.
            </p>
          </div>

          <div className="space-y-4 text-xs">
            <div>
              <label className="font-bold text-gray-700 block mb-1">
                Solar Micro-Cold Storage Fee (₹ / kg / week)
              </label>
              <input
                type="number"
                step="0.1"
                value={storageFeePerKg}
                onChange={(e) => setStorageFeePerKg(Number(e.target.value))}
                className="w-full p-2.5 rounded-xl border border-gray-300 font-bold text-gray-800 focus:outline-none focus:border-emerald-600"
              />
              <p className="text-[11px] text-gray-400 mt-1">
                Fair non-predatory fee covering solar battery depreciation and pre-cooling.
              </p>
            </div>

            <div>
              <label className="font-bold text-gray-700 block mb-1">
                Village Aggregation Service Margin (%)
              </label>
              <input
                type="number"
                step="0.5"
                value={aggregationMarginPct}
                onChange={(e) => setAggregationMarginPct(Number(e.target.value))}
                className="w-full p-2.5 rounded-xl border border-gray-300 font-bold text-gray-800 focus:outline-none focus:border-emerald-600"
              />
              <p className="text-[11px] text-gray-400 mt-1">
                Fee charged to corporate B2B buyer for standardized batch fulfillment.
              </p>
            </div>

            <div>
              <label className="font-bold text-gray-700 block mb-1">
                Shared Reefer Transit Base Cost (₹ / km)
              </label>
              <input
                type="number"
                value={transportCostPerKm}
                onChange={(e) => setTransportCostPerKm(Number(e.target.value))}
                className="w-full p-2.5 rounded-xl border border-gray-300 font-bold text-gray-800 focus:outline-none focus:border-emerald-600"
              />
            </div>

            <button
              onClick={handleSaveConfig}
              className="px-5 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-colors flex items-center gap-1.5 shadow-sm"
            >
              <Save className="w-3.5 h-3.5" />
              <span>Save Pricing Rules</span>
            </button>
          </div>
        </div>
      )}

      {/* TAB 3: AI ENGINE CONFIGURATION */}
      {activeAdminTab === 'ai' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6 max-w-2xl">
          <div>
            <h3 className="text-base font-bold text-[#18221E] font-heading">
              Computer Vision & Copilot Sensitivity Tuning
            </h3>
            <p className="text-xs text-gray-500">
              Calibrate grading acceptance thresholds and market confidence weights.
            </p>
          </div>

          <div className="space-y-4 text-xs">
            <div>
              <div className="flex justify-between font-bold text-gray-700 mb-1">
                <span>Minimum AI Grading Confidence for Auto-Suggestion</span>
                <span className="text-emerald-700">{aiConfidenceThreshold}%</span>
              </div>
              <input
                type="range"
                min="70"
                max="98"
                value={aiConfidenceThreshold}
                onChange={(e) => setAiConfidenceThreshold(Number(e.target.value))}
                className="w-full accent-[#1B4332]"
              />
              <p className="text-[11px] text-gray-400 mt-1">
                If model confidence falls below this threshold, operator manual physical grading is enforced.
              </p>
            </div>

            <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] space-y-2">
              <span className="font-bold text-gray-700 block">Active Micro-Services Architecture</span>
              <div className="grid grid-cols-2 gap-2 text-[11px]">
                <div className="p-2 bg-white rounded-lg border border-gray-200">
                  <span className="text-gray-500">ShelfLifeEngine:</span> <strong className="text-emerald-700">v2.4 Active</strong>
                </div>
                <div className="p-2 bg-white rounded-lg border border-gray-200">
                  <span className="text-gray-500">GradingVisionEngine:</span> <strong className="text-emerald-700">v3.1 Active</strong>
                </div>
                <div className="p-2 bg-white rounded-lg border border-gray-200">
                  <span className="text-gray-500">MarketIntelligence:</span> <strong className="text-emerald-700">v1.9 Active</strong>
                </div>
                <div className="p-2 bg-white rounded-lg border border-gray-200">
                  <span className="text-gray-500">AggregationEngine:</span> <strong className="text-emerald-700">v2.0 Active</strong>
                </div>
              </div>
            </div>

            <button
              onClick={handleSaveConfig}
              className="px-5 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-colors flex items-center gap-1.5 shadow-sm"
            >
              <Save className="w-3.5 h-3.5" />
              <span>Update AI Parameters</span>
            </button>
          </div>
        </div>
      )}

      {/* TAB 4: AUDIT LOGS */}
      {activeAdminTab === 'audit' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-4">
          <div className="flex items-center justify-between">
            <h3 className="text-base font-bold text-[#18221E] font-heading">
              Immutable System & Intake Audit Trail
            </h3>
            <span className="text-xs text-gray-500">Kurnool Node Audit Stream</span>
          </div>

          <div className="divide-y divide-gray-100 border border-[#E6E2D8] rounded-2xl overflow-hidden text-xs">
            {auditLogs.map((log, idx) => (
              <div key={idx} className="p-3.5 flex items-center justify-between hover:bg-[#FAF9F5]">
                <div className="flex items-center gap-3">
                  <span className="font-mono text-gray-400 text-[11px]">{log.time}</span>
                  <div>
                    <span className="font-bold text-gray-800">{log.user}: </span>
                    <span className="text-gray-600">{log.action}</span>
                  </div>
                </div>
                <span className="text-[10px] text-emerald-700 font-semibold bg-emerald-50 px-2 py-0.5 rounded">
                  Verified
                </span>
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};
