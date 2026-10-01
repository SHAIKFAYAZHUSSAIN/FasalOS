import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import { AggregationEngine } from '../../services/AggregationEngine';
import { BuyerRequirement } from '../../types';
import {
  ShoppingBag,
  Layers,
  Search,
  Filter,
  CheckCircle2,
  Truck,
  Sparkles,
  ArrowRight,
  ShieldCheck,
  Building,
  Calendar,
  Clock,
  PlusCircle,
  FileCheck,
} from 'lucide-react';

export const BuyerPortal: React.FC = () => {
  const {
    lots,
    buyerRequirements,
    activeTab,
    setActiveTab,
    aggregateLotsForRequirement,
    dispatchShipment,
    setCurrentRole,
  } = useApp();
  const { t } = useTranslation();

  const [selectedCropFilter, setSelectedCropFilter] = useState<string>('all');
  const [selectedGradeFilter, setSelectedGradeFilter] = useState<string>('all');
  const [activeReqId, setActiveReqId] = useState<string>('REQ-1048'); // Metro Fresh 10,000 kg

  // Selection of lot IDs for aggregation
  const [selectedLotIds, setSelectedLotIds] = useState<string[]>([
    'LOT-FOS-20481', // Lakshmi 250kg
    'LOT-FOS-20412', // Ramesh 1,200kg
    'LOT-FOS-20419', // Venkat 600kg
    'LOT-FOS-20398', // Srinivas 850kg
  ]);

  const activeRequirement = buyerRequirements.find((r) => r.id === activeReqId) || buyerRequirements[0];

  // Run aggregation calculation
  const aggResult = AggregationEngine.calculateAggregation(
    activeRequirement,
    lots,
    selectedLotIds
  );

  const toggleLotSelection = (lotId: string) => {
    setSelectedLotIds((prev) =>
      prev.includes(lotId) ? prev.filter((id) => id !== lotId) : [...prev, lotId]
    );
  };

  const handleConfirmAggregation = () => {
    aggregateLotsForRequirement(activeReqId, selectedLotIds);
  };

  const handleDispatch = () => {
    dispatchShipment(activeReqId);
    setCurrentRole('hub');
    setActiveTab('logistics');
  };

  const filteredLots = lots.filter((lot) => {
    if (selectedCropFilter !== 'all' && lot.cropId !== selectedCropFilter) return false;
    if (selectedGradeFilter !== 'all' && lot.grade !== selectedGradeFilter) return false;
    return true;
  });

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Header Banner */}
      <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3.5">
          <div className="w-12 h-12 rounded-2xl bg-purple-100 text-purple-800 flex items-center justify-center flex-shrink-0">
            <ShoppingBag className="w-6 h-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h1 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                {t.buyer.marketplaceTitle}
              </h1>
              <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-purple-100 text-purple-900 border border-purple-200">
                Direct B2B Procurement
              </span>
            </div>
            <p className="text-xs text-[#5C6761] font-medium">
              {t.buyer.marketplaceSubtitle}
            </p>
          </div>
        </div>

        {/* View Toggle Tabs */}
        <div className="flex items-center bg-[#FAF9F5] p-1 rounded-2xl border border-[#E6E2D8]">
          <button
            onClick={() => setActiveTab('marketplace')}
            className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all ${
              activeTab !== 'aggregate'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            Verified Inventory
          </button>
          <button
            onClick={() => setActiveTab('aggregate')}
            className={`px-3.5 py-1.5 rounded-xl text-xs font-bold transition-all flex items-center gap-1.5 ${
              activeTab === 'aggregate'
                ? 'bg-[#1B4332] text-white shadow-xs'
                : 'text-gray-600 hover:text-gray-900'
            }`}
          >
            <Layers className="w-3.5 h-3.5" />
            <span>Aggregation Engine</span>
          </button>
        </div>
      </div>

      {/* VIEW A: VERIFIED INVENTORY CATALOG */}
      {activeTab !== 'aggregate' && (
        <div className="space-y-5">
          {/* Filter Bar */}
          <div className="p-4 bg-white rounded-2xl border border-[#E6E2D8] flex flex-wrap items-center justify-between gap-3 text-xs">
            <div className="flex items-center gap-3">
              <div className="flex items-center gap-1.5 text-gray-500 font-semibold">
                <Filter className="w-3.5 h-3.5" />
                <span>Filters:</span>
              </div>
              <select
                value={selectedCropFilter}
                onChange={(e) => setSelectedCropFilter(e.target.value)}
                className="bg-[#FAF9F5] border border-[#E6E2D8] rounded-xl px-2.5 py-1.5 font-medium text-gray-700"
              >
                <option value="all">All Crops</option>
                <option value="tomato">Tomatoes</option>
                <option value="mango">Mangoes</option>
                <option value="banana">Bananas</option>
              </select>

              <select
                value={selectedGradeFilter}
                onChange={(e) => setSelectedGradeFilter(e.target.value)}
                className="bg-[#FAF9F5] border border-[#E6E2D8] rounded-xl px-2.5 py-1.5 font-medium text-gray-700"
              >
                <option value="all">All Grades</option>
                <option value="A">Grade A (Premium)</option>
                <option value="B">Grade B (Wholesale)</option>
                <option value="C">Grade C (Processing)</option>
              </select>
            </div>

            <div className="text-gray-500 font-medium">
              Showing <strong className="text-gray-800">{filteredLots.length}</strong> standardized lots from Kurnool Hub
            </div>
          </div>

          {/* Lots Grid */}
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
            {filteredLots.map((lot) => (
              <div
                key={lot.id}
                className="bg-white rounded-3xl p-5 border border-[#E6E2D8] hover:border-purple-400 shadow-xs hover:shadow-md transition-all space-y-3"
              >
                <div className="flex items-center justify-between">
                  <span className="font-mono text-xs font-bold text-gray-500 bg-[#FAF9F5] px-2 py-0.5 rounded border border-gray-200">
                    {lot.id}
                  </span>
                  <span className="text-xs font-bold text-emerald-800 bg-[#D8F3DC] px-2.5 py-0.5 rounded-full border border-emerald-300">
                    Grade {lot.grade}
                  </span>
                </div>

                <div>
                  <h3 className="text-base font-bold text-[#18221E] font-heading">
                    {lot.quantityKg} kg {lot.cropName}
                  </h3>
                  <p className="text-xs text-gray-500">
                    {lot.variety} · Stored in {lot.coldRoomId === 'CR-01' ? 'Cold Room A (8.2°C)' : 'Cold Room B'}
                  </p>
                </div>

                <div className="p-2.5 bg-[#FAF9F5] rounded-xl text-xs space-y-1">
                  <div className="flex justify-between">
                    <span className="text-gray-500">Freshness Score:</span>
                    <span className="font-bold text-emerald-700">{lot.freshnessScore}/100</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Commercial Shelf Life:</span>
                    <span className="font-bold text-gray-700">~{Math.round(lot.commercialShelfLifeHours / 24)} Days</span>
                  </div>
                  <div className="flex justify-between">
                    <span className="text-gray-500">Farmer:</span>
                    <span className="text-gray-800 font-semibold">{lot.farmerName} ({lot.village})</span>
                  </div>
                </div>

                <button
                  onClick={() => {
                    setActiveTab('aggregate');
                    if (!selectedLotIds.includes(lot.id)) {
                      setSelectedLotIds((prev) => [...prev, lot.id]);
                    }
                  }}
                  className="w-full py-2 rounded-xl bg-purple-50 text-purple-900 border border-purple-200 text-xs font-bold hover:bg-purple-100 transition-colors flex items-center justify-center gap-1.5"
                >
                  <Layers className="w-3.5 h-3.5 text-purple-700" />
                  <span>Add to Order Aggregation</span>
                </button>
              </div>
            ))}
          </div>
        </div>
      )}

      {/* VIEW B: THE SIGNATURE VILLAGE AGGREGATION ENGINE */}
      {activeTab === 'aggregate' && (
        <div className="space-y-6">
          {/* Active Requirement Card */}
          <div className="bg-gradient-to-br from-[#18221E] via-[#24352D] to-[#143626] text-white rounded-3xl p-6 shadow-xl space-y-5">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-3 pb-4 border-b border-gray-700">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-amber-400 text-amber-950 flex items-center justify-center font-bold">
                  <Building className="w-5 h-5" />
                </div>
                <div>
                  <div className="flex items-center gap-2">
                    <h3 className="font-bold text-lg font-heading text-white">
                      {activeRequirement.companyName}
                    </h3>
                    <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-500 text-black">
                      Verified Buyer
                    </span>
                  </div>
                  <p className="text-xs text-emerald-200">
                    Purchase Order #{activeRequirement.id} · Delivery to {activeRequirement.destination}
                  </p>
                </div>
              </div>

              <div className="text-right">
                <span className="text-[10px] text-gray-400 uppercase font-bold">Offered Price</span>
                <div className="text-2xl font-black text-amber-400 font-heading">
                  ₹{activeRequirement.offeredPricePerKg}.00 <span className="text-xs text-gray-300 font-normal">/ kg</span>
                </div>
              </div>
            </div>

            {/* Aggregation Progress Bar */}
            <div className="space-y-2">
              <div className="flex justify-between text-xs">
                <span className="font-semibold text-gray-300">
                  Aggregation Progress: <strong className="text-white">{aggResult.aggregatedQuantityKg.toLocaleString('en-IN')} kg</strong> of {activeRequirement.quantityNeededKg.toLocaleString('en-IN')} kg
                </span>
                <span className="font-bold text-amber-300">{aggResult.fulfillmentPct}% Filled</span>
              </div>
              <div className="w-full h-3 rounded-full bg-gray-700 overflow-hidden">
                <div
                  className="h-full bg-gradient-to-r from-emerald-400 to-amber-400 rounded-full transition-all duration-500"
                  style={{ width: `${aggResult.fulfillmentPct}%` }}
                />
              </div>
            </div>

            {/* Key Calculated Aggregation Metrics */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-3 pt-2 text-xs">
              <div className="p-3 rounded-2xl bg-white/10 backdrop-blur-xs border border-white/10">
                <div className="text-gray-300 text-[10px] uppercase font-semibold">Smallholders Aggregated</div>
                <div className="text-lg font-black text-white mt-0.5">{aggResult.farmerCount} Farmers</div>
                <div className="text-[10px] text-emerald-300">Unified batch</div>
              </div>

              <div className="p-3 rounded-2xl bg-white/10 backdrop-blur-xs border border-white/10">
                <div className="text-gray-300 text-[10px] uppercase font-semibold">Weighted Farmer Payout</div>
                <div className="text-lg font-black text-white mt-0.5">₹{aggResult.weightedAvgCostPerKg}.00 / kg</div>
                <div className="text-[10px] text-gray-300">Net direct payout</div>
              </div>

              <div className="p-3 rounded-2xl bg-white/10 backdrop-blur-xs border border-white/10">
                <div className="text-gray-300 text-[10px] uppercase font-semibold">Reefer Transport Cost</div>
                <div className="text-lg font-black text-white mt-0.5">₹{aggResult.estimatedTransportCost.toLocaleString('en-IN')}</div>
                <div className="text-[10px] text-gray-300">₹2.50/kg shared freight</div>
              </div>

              <div className="p-3 rounded-2xl bg-emerald-900/60 backdrop-blur-xs border border-emerald-500/40">
                <div className="text-emerald-300 text-[10px] uppercase font-semibold">Hub Operating Margin</div>
                <div className="text-lg font-black text-amber-300 mt-0.5">
                  ₹{Math.max(0, aggResult.estimatedNetHubMargin).toLocaleString('en-IN')}
                </div>
                <div className="text-[10px] text-emerald-200">Reinvested in solar micro-storage</div>
              </div>
            </div>
          </div>

          {/* Aggregated Lots Breakdown & Selector */}
          <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-4">
            <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-2">
              <div>
                <h3 className="font-bold text-base text-[#18221E] font-heading">
                  Smallholder Lots Contributed to this 10-Tonne Batch
                </h3>
                <p className="text-xs text-gray-500">
                  Select and aggregate individual farmer crates into the single standardized B2B shipment.
                </p>
              </div>

              <div className="flex items-center gap-2">
                <button
                  onClick={handleConfirmAggregation}
                  className="px-4 py-2 rounded-xl bg-purple-700 text-white text-xs font-bold hover:bg-purple-800 transition-colors shadow-xs"
                >
                  Save Aggregation
                </button>
                <button
                  onClick={handleDispatch}
                  className="flex items-center gap-1.5 px-4 py-2 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all shadow-md shadow-emerald-950/20"
                >
                  <Truck className="w-3.5 h-3.5" />
                  <span>Dispatch Reefer</span>
                  <ArrowRight className="w-3.5 h-3.5" />
                </button>
              </div>
            </div>

            {/* List of Lots Available for Aggregation */}
            <div className="divide-y divide-gray-100 border border-[#E6E2D8] rounded-2xl overflow-hidden">
              {lots.map((lot) => {
                const isSelected = selectedLotIds.includes(lot.id);
                return (
                  <div
                    key={lot.id}
                    onClick={() => toggleLotSelection(lot.id)}
                    className={`p-4 flex items-center justify-between text-xs cursor-pointer transition-colors ${
                      isSelected ? 'bg-purple-50/50' : 'hover:bg-[#FAF9F5]'
                    }`}
                  >
                    <div className="flex items-center gap-3">
                      <input
                        type="checkbox"
                        checked={isSelected}
                        onChange={() => toggleLotSelection(lot.id)}
                        className="w-4 h-4 text-purple-600 rounded border-gray-300 focus:ring-purple-500"
                      />
                      <div>
                        <div className="font-bold text-[#18221E] flex items-center gap-2">
                          <span>{lot.farmerName}</span>
                          <span className="font-mono text-[10px] text-gray-500 bg-gray-100 px-1.5 py-0.5 rounded">
                            {lot.id}
                          </span>
                        </div>
                        <div className="text-[11px] text-gray-500 mt-0.5">
                          {lot.village} · Harvested {lot.harvestTimestamp.slice(11, 16)} · Freshness: {lot.freshnessScore}/100
                        </div>
                      </div>
                    </div>

                    <div className="flex items-center gap-4">
                      <div className="text-right">
                        <div className="font-black text-sm text-[#18221E]">{lot.quantityKg} kg</div>
                        <div className="text-[10px] text-emerald-700 font-semibold">Grade {lot.grade}</div>
                      </div>
                      <span className={`px-2 py-0.5 rounded-full text-[10px] font-bold ${
                        isSelected ? 'bg-purple-200 text-purple-900' : 'bg-gray-100 text-gray-500'
                      }`}>
                        {isSelected ? 'Aggregated' : 'Available'}
                      </span>
                    </div>
                  </div>
                );
              })}
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
