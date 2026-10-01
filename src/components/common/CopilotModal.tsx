import React from 'react';
import { useApp } from '../../context/AppContext';
import { MarketIntelligenceEngine } from '../../services/MarketIntelligenceEngine';
import {
  X,
  Sparkles,
  TrendingUp,
  Truck,
  CheckCircle2,
  Info,
  ArrowRight,
  ShieldAlert,
  Clock,
  MapPin,
} from 'lucide-react';

export const CopilotModal: React.FC = () => {
  const { showCopilotModal, setShowCopilotModal, copilotLot, marketPrices, setCurrentRole, setActiveTab } = useApp();

  if (!showCopilotModal || !copilotLot) return null;

  const analysis = MarketIntelligenceEngine.analyzeOptions({
    cropId: copilotLot.cropId,
    cropName: copilotLot.cropName,
    quantityKg: copilotLot.quantityKg,
    grade: copilotLot.grade,
    freshnessScore: copilotLot.freshnessScore,
    marketPrices,
  });

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-3 sm:p-4 bg-black/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div className="bg-white rounded-3xl shadow-2xl max-w-2xl w-full overflow-hidden border border-[#E6E2D8] flex flex-col max-h-[92vh]">
        {/* Header */}
        <div className="bg-gradient-to-r from-[#1B4332] via-[#2D6A4F] to-[#143626] text-white p-4 sm:p-5 flex items-center justify-between">
          <div className="flex items-center gap-3">
            <div className="w-10 h-10 rounded-xl bg-white/10 flex items-center justify-center border border-white/20 text-amber-300">
              <Sparkles className="w-5 h-5 animate-pulse" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h3 className="font-bold text-lg font-heading">FasalOS Copilot</h3>
                <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-amber-400 text-amber-950">
                  AI Intelligence
                </span>
              </div>
              <p className="text-xs text-emerald-100 font-medium">
                Understand your inventory. Explore your options.
              </p>
            </div>
          </div>
          <button
            onClick={() => setShowCopilotModal(false)}
            className="p-1 rounded-lg text-emerald-200 hover:text-white hover:bg-white/10 transition-colors"
          >
            <X className="w-5 h-5" />
          </button>
        </div>

        {/* Content Body */}
        <div className="p-4 sm:p-6 overflow-y-auto space-y-5 bg-[#FAF9F5]/40 text-[#18221E]">
          {/* Produce Context Banner */}
          <div className="p-3.5 bg-white rounded-2xl border border-[#E6E2D8] shadow-sm flex flex-wrap items-center justify-between gap-3">
            <div className="flex items-center gap-2.5">
              <div className="w-9 h-9 rounded-lg bg-[#D8F3DC] text-[#1B4332] flex items-center justify-center font-bold text-sm">
                {copilotLot.quantityKg}kg
              </div>
              <div>
                <h4 className="text-sm font-bold text-[#18221E]">
                  {copilotLot.cropName} · {copilotLot.id}
                </h4>
                <p className="text-xs text-[#5C6761]">
                  Farmer: <span className="font-semibold text-gray-800">{copilotLot.farmerName}</span> (Grade {copilotLot.grade})
                </p>
              </div>
            </div>

            <div className="flex items-center gap-2 text-xs">
              <div className="bg-[#FAF9F5] px-2.5 py-1 rounded-lg border border-[#E6E2D8]">
                <span className="text-gray-500">Freshness: </span>
                <span className="font-bold text-emerald-700">{copilotLot.freshnessScore}/100</span>
              </div>
              <div className="bg-[#FAF9F5] px-2.5 py-1 rounded-lg border border-[#E6E2D8]">
                <span className="text-gray-500">Shelf window: </span>
                <span className="font-bold text-amber-700">~{Math.round(copilotLot.commercialShelfLifeHours / 24)} days</span>
              </div>
            </div>
          </div>

          {/* AI Recommendation Highlight Box */}
          <div className="p-4 rounded-2xl bg-gradient-to-br from-emerald-50 via-teal-50/50 to-amber-50/40 border border-emerald-300 shadow-sm">
            <div className="flex items-center gap-2 mb-1.5">
              <span className="text-xs font-bold uppercase tracking-wider text-emerald-800 flex items-center gap-1.5">
                <Sparkles className="w-3.5 h-3.5 text-amber-600" />
                Here's what we found
              </span>
              <span className="text-[10px] text-gray-500">Updated {analysis.calculatedAt}</span>
            </div>
            <p className="text-xs sm:text-sm font-semibold text-[#18221E] leading-relaxed">
              {analysis.recommendedExplanation}
            </p>
            <div className="mt-2.5 pt-2 border-t border-emerald-200/60 flex items-center justify-between text-xs text-gray-600">
              <span className="flex items-center gap-1 text-[11px]">
                <CheckCircle2 className="w-3.5 h-3.5 text-emerald-600" />
                Model Confidence: <span className="font-bold text-gray-800">{analysis.confidenceScorePct}%</span>
              </span>
              <span className="text-[11px] text-emerald-800 font-semibold">
                Estimated Net Uplift: +28.5%
              </span>
            </div>
          </div>

          {/* Multi-Market Selling Options Comparison Table */}
          <div>
            <div className="flex items-center justify-between mb-2">
              <h5 className="text-xs font-bold uppercase tracking-wider text-[#5C6761]">
                Market Destination Options Comparison
              </h5>
              <span className="text-[11px] text-gray-400">Net after simulated transport</span>
            </div>

            <div className="space-y-2.5">
              {analysis.options.map((option, idx) => {
                const isRecommended = option.marketName === analysis.recommendedOption;
                return (
                  <div
                    key={idx}
                    className={`p-3.5 rounded-2xl border transition-all ${
                      isRecommended
                        ? 'bg-white border-emerald-500 shadow-md ring-1 ring-emerald-500/20'
                        : 'bg-white border-[#E6E2D8] hover:border-gray-300'
                    }`}
                  >
                    <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
                      <div className="flex items-start gap-2.5">
                        <div
                          className={`w-7 h-7 rounded-lg flex items-center justify-center font-bold text-xs flex-shrink-0 mt-0.5 ${
                            isRecommended
                              ? 'bg-emerald-100 text-emerald-800'
                              : 'bg-gray-100 text-gray-700'
                          }`}
                        >
                          {String.fromCharCode(65 + idx)}
                        </div>
                        <div>
                          <div className="flex items-center gap-2">
                            <h6 className="text-xs sm:text-sm font-bold text-[#18221E]">
                              {option.marketName}
                            </h6>
                            {isRecommended && (
                              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-600 text-white">
                                Highest Net
                              </span>
                            )}
                          </div>
                          <div className="flex items-center gap-3 text-[11px] text-gray-500 mt-0.5">
                            <span className="flex items-center gap-1">
                              <MapPin className="w-3 h-3 text-gray-400" />
                              {option.location} ({option.distanceKm} km)
                            </span>
                            <span>·</span>
                            <span>Transit: ~{option.transitHours}h</span>
                            <span>·</span>
                            <span className="font-medium text-emerald-700">Demand: {option.demandLevel}</span>
                          </div>
                        </div>
                      </div>

                      {/* Financials Column */}
                      <div className="flex items-center justify-between sm:justify-end gap-4 border-t sm:border-t-0 pt-2 sm:pt-0 border-gray-100">
                        <div className="text-right">
                          <div className="text-[10px] text-gray-400 uppercase">Gross Price</div>
                          <div className="text-xs font-semibold text-gray-700">₹{option.currentPrice}/kg</div>
                        </div>
                        <div className="text-right">
                          <div className="text-[10px] text-gray-400 uppercase">Transport</div>
                          <div className="text-xs font-semibold text-amber-700">
                            -₹{option.transportCostPerKg.toFixed(2)}/kg
                          </div>
                        </div>
                        <div className="text-right pl-2 sm:border-l border-gray-200">
                          <div className="text-[10px] font-bold text-emerald-800 uppercase">Expected Net</div>
                          <div className="text-sm sm:text-base font-black text-[#1B4332]">
                            ₹{option.expectedNetPerKg.toFixed(2)}/kg
                          </div>
                        </div>
                      </div>
                    </div>

                    {/* Bottom Total for the batch */}
                    <div className="mt-2 pt-2 border-t border-gray-100 flex items-center justify-between text-[11px]">
                      <span className="text-gray-500">
                        Total realization for {copilotLot.quantityKg} kg:
                      </span>
                      <span className="font-bold text-gray-800">
                        ₹{option.totalExpectedNet.toLocaleString('en-IN')}{' '}
                        {option.netGainVsLocalTotal > 0 && (
                          <span className="text-emerald-700 font-semibold">
                            (+₹{option.netGainVsLocalTotal.toLocaleString('en-IN')} vs local)
                          </span>
                        )}
                      </span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>

          {/* Model Assumptions & Disclaimers */}
          <div className="p-3 bg-[#F4F1EA] rounded-xl text-xs space-y-1.5 border border-[#E4DFD3]">
            <div className="flex items-center gap-1.5 font-bold text-gray-700">
              <Info className="w-3.5 h-3.5 text-gray-500" />
              <span>Assumptions & Model Parameters</span>
            </div>
            <ul className="text-[11px] text-gray-600 list-disc list-inside space-y-0.5">
              {analysis.assumptions.map((assump, i) => (
                <li key={i}>{assump}</li>
              ))}
            </ul>
            <p className="text-[10px] text-gray-500 italic pt-1">
              FasalOS utilizes simulated deterministic market data for demonstration purposes. Final realization is subject to verified buyer intake and grading.
            </p>
          </div>
        </div>

        {/* Modal Actions */}
        <div className="p-4 bg-white border-t border-[#E6E2D8] flex items-center justify-between">
          <button
            onClick={() => setShowCopilotModal(false)}
            className="px-4 py-2 rounded-xl border border-gray-300 text-xs font-semibold text-gray-700 hover:bg-gray-50 transition-colors"
          >
            Close
          </button>
          <button
            onClick={() => {
              setShowCopilotModal(false);
              setCurrentRole('buyer');
              setActiveTab('aggregate');
            }}
            className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all shadow-md shadow-emerald-950/20"
          >
            <span>Proceed to Buyer Aggregation</span>
            <ArrowRight className="w-3.5 h-3.5" />
          </button>
        </div>
      </div>
    </div>
  );
};
