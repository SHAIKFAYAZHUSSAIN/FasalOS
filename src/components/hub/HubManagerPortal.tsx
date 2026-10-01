import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import {
  Warehouse,
  Sun,
  BatteryCharging,
  Thermometer,
  Droplets,
  Clock,
  AlertTriangle,
  Truck,
  Users,
  ShoppingBag,
  TrendingUp,
  ArrowRight,
  ShieldCheck,
  Zap,
  Repeat,
  Layers,
  Sparkles,
  MapPin,
  CheckCircle2,
} from 'lucide-react';

export const HubManagerPortal: React.FC = () => {
  const {
    coldRooms,
    lots,
    shipment,
    impactMetrics,
    setCurrentRole,
    setActiveTab,
    openCopilotForLot,
  } = useApp();
  const { t } = useTranslation();

  const [activeHubView, setActiveHubView] = useState<'telemetry' | 'inventory' | 'logistics' | 'processing'>('telemetry');

  // Cold Room A (primary)
  const roomA = coldRooms[0];
  const roomB = coldRooms[1];

  // At-risk lots (freshness < 70)
  const atRiskLots = lots.filter((l) => l.freshnessScore < 70);

  return (
    <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6 space-y-6">
      {/* Hub Header & Status Bar */}
      <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm">
        <div className="flex flex-col sm:flex-row sm:items-center justify-between gap-4 pb-5 border-b border-[#EAE6DD]">
          <div className="flex items-center gap-3.5">
            <div className="w-12 h-12 rounded-2xl bg-blue-100 text-blue-800 flex items-center justify-center flex-shrink-0">
              <Warehouse className="w-6 h-6" />
            </div>
            <div>
              <div className="flex items-center gap-2">
                <h1 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                  {t.hub.title}
                </h1>
                <span className="text-[10px] font-bold px-2.5 py-0.5 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200">
                  Operational · 24/7 Monitoring
                </span>
              </div>
              <p className="text-xs text-[#5C6761] font-medium">
                {t.hub.kurnoolHub} · Solar-Thermal Autonomous Node #04
              </p>
            </div>
          </div>

          {/* Sub Navigation Tabs */}
          <div className="flex flex-wrap items-center bg-[#FAF9F5] p-1 rounded-2xl border border-[#E6E2D8]">
            <button
              onClick={() => setActiveHubView('telemetry')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                activeHubView === 'telemetry'
                  ? 'bg-[#1B4332] text-white shadow-xs'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Cold Room & Solar
            </button>
            <button
              onClick={() => setActiveHubView('inventory')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                activeHubView === 'inventory'
                  ? 'bg-[#1B4332] text-white shadow-xs'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Inventory & Risk
            </button>
            <button
              onClick={() => setActiveHubView('logistics')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                activeHubView === 'logistics'
                  ? 'bg-[#1B4332] text-white shadow-xs'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Logistics & Transit
            </button>
            <button
              onClick={() => setActiveHubView('processing')}
              className={`px-3 py-1.5 rounded-xl text-xs font-bold transition-all ${
                activeHubView === 'processing'
                  ? 'bg-[#1B4332] text-white shadow-xs'
                  : 'text-gray-600 hover:text-gray-900'
              }`}
            >
              Processing Routing
            </button>
          </div>
        </div>

        {/* 6 Key Operational Status Indicators */}
        <div className="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-6 gap-3 pt-5">
          <div className="p-3 bg-[#FAF9F5] rounded-2xl border border-[#EAE6DD]">
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block mb-1">
              {t.hub.metricFarmers}
            </span>
            <div className="text-xl font-black text-[#143626] font-heading">
              {impactMetrics.farmersServed}
            </div>
            <div className="text-[10px] text-emerald-700 font-semibold mt-0.5">8 villages linked</div>
          </div>

          <div className="p-3 bg-[#FAF9F5] rounded-2xl border border-[#EAE6DD]">
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block mb-1">
              {t.hub.metricInventory}
            </span>
            <div className="text-xl font-black text-[#143626] font-heading">
              {impactMetrics.produceHandledTonnes} <span className="text-xs font-normal text-gray-500">Tonnes</span>
            </div>
            <div className="text-[10px] text-gray-500 font-medium mt-0.5">Active across 2 rooms</div>
          </div>

          <div className="p-3 bg-[#FAF9F5] rounded-2xl border border-[#EAE6DD]">
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block mb-1">
              {t.hub.metricColdRoom}
            </span>
            <div className="text-xl font-black text-[#143626] font-heading">
              {impactMetrics.hubUtilizationPct}%
            </div>
            <div className="text-[10px] text-emerald-700 font-semibold mt-0.5">Healthy thermal load</div>
          </div>

          <div className="p-3 bg-[#FAF9F5] rounded-2xl border border-[#EAE6DD]">
            <span className="text-[10px] font-bold text-gray-400 uppercase tracking-wider block mb-1">
              {t.hub.metricOrders}
            </span>
            <div className="text-xl font-black text-[#143626] font-heading">
              {impactMetrics.b2bOrdersFulfilled}
            </div>
            <div className="text-[10px] text-blue-700 font-semibold mt-0.5">₹21/kg peak offer</div>
          </div>

          <div className="p-3 bg-amber-50/70 rounded-2xl border border-amber-200">
            <span className="text-[10px] font-bold text-amber-800 uppercase tracking-wider block mb-1">
              {t.hub.metricAtRisk}
            </span>
            <div className="text-xl font-black text-amber-900 font-heading">
              420 kg
            </div>
            <div className="text-[10px] text-amber-800 font-semibold mt-0.5">~32h window remaining</div>
          </div>

          <div className="p-3 bg-emerald-50/70 rounded-2xl border border-emerald-200">
            <span className="text-[10px] font-bold text-emerald-800 uppercase tracking-wider block mb-1">
              {t.hub.metricSolar}
            </span>
            <div className="text-xl font-black text-emerald-900 font-heading">
              {impactMetrics.solarEnergyContributionPct}%
            </div>
            <div className="text-[10px] text-emerald-800 font-semibold mt-0.5">62 kWh solar today</div>
          </div>
        </div>
      </div>

      {/* VIEW 1: COLD ROOM TELEMETRY & SOLAR ENERGY */}
      {activeHubView === 'telemetry' && (
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Cold Room A Card */}
          <div className="lg:col-span-2 bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6">
            <div className="flex items-center justify-between pb-4 border-b border-gray-100">
              <div className="flex items-center gap-3">
                <div className="w-10 h-10 rounded-xl bg-emerald-100 text-emerald-800 flex items-center justify-center">
                  <Warehouse className="w-5 h-5" />
                </div>
                <div>
                  <h3 className="text-lg font-black text-[#18221E] font-heading">
                    {roomA.name}
                  </h3>
                  <p className="text-xs text-gray-500">
                    Vegetables & Berries · Capacity 8,000 kg ({roomA.occupiedKg} kg occupied · 68%)
                  </p>
                </div>
              </div>
              <span className="text-xs font-bold px-3 py-1 rounded-full bg-emerald-100 text-emerald-800 border border-emerald-200 flex items-center gap-1.5">
                <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                {roomA.coolingStatus}
              </span>
            </div>

            {/* Gauge Metrics Grid */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-4">
              <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] text-center">
                <div className="w-8 h-8 rounded-lg bg-blue-100 text-blue-800 flex items-center justify-center mx-auto mb-2">
                  <Thermometer className="w-4 h-4" />
                </div>
                <div className="text-xs text-gray-500 font-semibold">{t.hub.temp}</div>
                <div className="text-2xl font-black text-[#143626] font-heading mt-0.5">
                  {roomA.currentTempC}°C
                </div>
                <div className="text-[10px] text-gray-400 mt-1">Target: {roomA.targetTempC}°C</div>
              </div>

              <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] text-center">
                <div className="w-8 h-8 rounded-lg bg-teal-100 text-teal-800 flex items-center justify-center mx-auto mb-2">
                  <Droplets className="w-4 h-4" />
                </div>
                <div className="text-xs text-gray-500 font-semibold">{t.hub.humidity}</div>
                <div className="text-2xl font-black text-[#143626] font-heading mt-0.5">
                  {roomA.currentHumidityPct}%
                </div>
                <div className="text-[10px] text-gray-400 mt-1">Target: {roomA.targetHumidityPct}%</div>
              </div>

              <div className="p-4 rounded-2xl bg-cyan-50/70 border border-cyan-200 text-center">
                <div className="w-8 h-8 rounded-lg bg-cyan-100 text-cyan-800 flex items-center justify-center mx-auto mb-2">
                  <Clock className="w-4 h-4" />
                </div>
                <div className="text-xs text-cyan-900 font-bold">{t.hub.thermalReserve}</div>
                <div className="text-2xl font-black text-cyan-950 font-heading mt-0.5">
                  6h 20m
                </div>
                <div className="text-[10px] text-cyan-800 mt-1">Zero-grid hold time</div>
              </div>

              <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] text-center">
                <div className="w-8 h-8 rounded-lg bg-gray-100 text-gray-700 flex items-center justify-center mx-auto mb-2">
                  <Repeat className="w-4 h-4" />
                </div>
                <div className="text-xs text-gray-500 font-semibold">{t.hub.doorActivity}</div>
                <div className="text-2xl font-black text-[#143626] font-heading mt-0.5">
                  {roomA.doorOpeningsToday}
                </div>
                <div className="text-[10px] text-emerald-700 font-semibold mt-1">Thermal seal good</div>
              </div>
            </div>

            {/* Explanation Note */}
            <div className="p-3 bg-emerald-50/60 rounded-xl border border-emerald-200 text-xs text-emerald-900 flex items-start gap-2">
              <ShieldCheck className="w-4 h-4 text-emerald-700 flex-shrink-0 mt-0.5" />
              <span>
                <strong>Signature FasalOS Feature:</strong> Rather than only displaying static temperature, FasalOS calculates real-time <strong>Thermal Reserve Hold</strong>. If grid power fails, the phase-change material holds safe storage for 6 hours 20 minutes without spoilage risk.
              </span>
            </div>
          </div>

          {/* Solar Energy Card */}
          <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-5 flex flex-col justify-between">
            <div>
              <div className="flex items-center justify-between pb-3 border-b border-gray-100 mb-4">
                <div className="flex items-center gap-2.5">
                  <div className="w-9 h-9 rounded-xl bg-amber-100 text-amber-800 flex items-center justify-center">
                    <Sun className="w-5 h-5" />
                  </div>
                  <div>
                    <h3 className="font-bold text-base text-[#18221E] font-heading">Solar Generation</h3>
                    <p className="text-xs text-gray-500">Rooftop Solar Array (12 kWp)</p>
                  </div>
                </div>
                <span className="text-base font-black text-amber-700 font-heading">
                  {roomA.solarContributionPct}%
                </span>
              </div>

              {/* Energy Split Bars */}
              <div className="space-y-3 text-xs">
                <div>
                  <div className="flex justify-between font-semibold mb-1">
                    <span className="text-gray-600">Solar Energy Generated</span>
                    <span className="text-emerald-800 font-bold">{roomA.solarGeneratedTodayKwh} kWh</span>
                  </div>
                  <div className="w-full h-2 rounded-full bg-gray-100 overflow-hidden">
                    <div className="h-full bg-amber-400 rounded-full" style={{ width: '74%' }} />
                  </div>
                </div>

                <div>
                  <div className="flex justify-between font-semibold mb-1">
                    <span className="text-gray-600">Grid / Backup Consumed</span>
                    <span className="text-gray-800 font-bold">{roomA.gridConsumedTodayKwh} kWh</span>
                  </div>
                  <div className="w-full h-2 rounded-full bg-gray-100 overflow-hidden">
                    <div className="h-full bg-gray-400 rounded-full" style={{ width: '26%' }} />
                  </div>
                </div>
              </div>

              {/* Battery & Thermal Storage */}
              <div className="mt-5 p-3.5 rounded-2xl bg-[#FAF9F5] border border-[#EAE6DD] text-xs space-y-2">
                <div className="flex items-center justify-between">
                  <span className="font-bold text-gray-700 flex items-center gap-1.5">
                    <BatteryCharging className="w-4 h-4 text-emerald-600" />
                    Storage Bank Status
                  </span>
                  <span className="text-emerald-700 font-bold">94% Charged</span>
                </div>
                <p className="text-[11px] text-gray-500 leading-relaxed">
                  Solar peak charging powers continuous chilling compressor while simultaneously freezing thermal reserve eutectic plates.
                </p>
              </div>
            </div>

            <div className="pt-3 border-t border-gray-100 text-center text-xs text-gray-500">
              Zero diesel generator fuel burned today.
            </div>
          </div>
        </div>
      )}

      {/* VIEW 2: INVENTORY & AT-RISK WATCHLIST */}
      {activeHubView === 'inventory' && (
        <div className="space-y-6">
          {/* At-Risk Watchlist Banner */}
          <div className="bg-amber-50/90 border border-amber-300 rounded-3xl p-5 shadow-xs">
            <div className="flex items-center justify-between gap-3 mb-3">
              <div className="flex items-center gap-2">
                <AlertTriangle className="w-5 h-5 text-amber-700" />
                <h3 className="font-bold text-base text-amber-950 font-heading">
                  Dynamic Shelf-Life Risk Watchlist
                </h3>
              </div>
              <span className="text-xs font-bold px-2.5 py-0.5 rounded-full bg-amber-200 text-amber-900">
                Action Recommended
              </span>
            </div>

            <p className="text-xs text-amber-900 leading-relaxed mb-4 max-w-2xl">
              FasalOS monitors decay kinetics continuously. The following lots are nearing the end of their commercial freshness window and should be routed to quick wholesale or processing destinations.
            </p>

            <div className="space-y-3">
              {atRiskLots.map((lot) => (
                <div
                  key={lot.id}
                  className="bg-white rounded-2xl p-4 border border-amber-200 shadow-xs flex flex-col sm:flex-row sm:items-center justify-between gap-3"
                >
                  <div>
                    <div className="flex items-center gap-2">
                      <span className="font-mono font-bold text-xs bg-amber-100 text-amber-900 px-2 py-0.5 rounded">
                        {lot.id}
                      </span>
                      <h4 className="font-bold text-sm text-[#18221E]">
                        {lot.quantityKg} kg {lot.cropName} ({lot.variety})
                      </h4>
                      <span className="text-xs text-gray-500">Farmer: {lot.farmerName}</span>
                    </div>
                    <p className="text-xs text-amber-800 mt-1">
                      {lot.recommendedAction}
                    </p>
                  </div>

                  <div className="flex items-center gap-3">
                    <div className="text-right">
                      <div className="text-[10px] text-gray-400 uppercase font-bold">Remaining</div>
                      <div className="text-base font-black text-amber-800 font-heading">
                        ~{lot.commercialShelfLifeHours} Hours
                      </div>
                    </div>
                    <button
                      onClick={() => openCopilotForLot(lot)}
                      className="px-3 py-2 rounded-xl bg-amber-700 text-white text-xs font-bold hover:bg-amber-800 transition-colors shadow-xs"
                    >
                      Route to Buyer
                    </button>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Full Traceable Lot Inventory */}
          <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-4">
            <div className="flex items-center justify-between">
              <h3 className="font-bold text-base text-[#18221E] font-heading">
                All Traceable Batches in Hub ({lots.length})
              </h3>
              <span className="text-xs text-gray-500">Sorted by freshness</span>
            </div>

            <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
              {lots.map((lot) => (
                <div
                  key={lot.id}
                  className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] hover:border-emerald-500 transition-all space-y-2.5"
                >
                  <div className="flex items-center justify-between">
                    <span className="font-mono text-xs font-bold text-gray-500 bg-white px-2 py-0.5 rounded border border-gray-200">
                      {lot.id}
                    </span>
                    <span className="text-xs font-bold text-emerald-800 bg-[#D8F3DC] px-2 py-0.5 rounded">
                      Grade {lot.grade}
                    </span>
                  </div>

                  <div>
                    <h4 className="font-bold text-sm text-[#18221E]">{lot.farmerName}</h4>
                    <p className="text-xs text-gray-600">
                      {lot.quantityKg} kg {lot.cropName} · {lot.village}
                    </p>
                  </div>

                  <div className="flex justify-between text-xs pt-1 border-t border-gray-200">
                    <span>Freshness: <strong className="text-emerald-700">{lot.freshnessScore}/100</strong></span>
                    <span className="text-gray-500">{lot.coldRoomId === 'CR-01' ? 'Cold Room A' : 'Cold Room B'}</span>
                  </div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* VIEW 3: LOGISTICS & TRANSIT */}
      {activeHubView === 'logistics' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6">
          <div className="flex items-center justify-between pb-4 border-b border-gray-100">
            <div>
              <h3 className="text-lg font-black text-[#18221E] font-heading">
                {t.logistics.title}
              </h3>
              <p className="text-xs text-gray-500">Active Reefer Vehicle Dispatches from Kurnool Hub</p>
            </div>
            <span className="text-xs font-bold px-3 py-1 rounded-full bg-blue-100 text-blue-800">
              Active Shipment #SHIP-FOS-901
            </span>
          </div>

          <div className="p-5 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] grid grid-cols-1 md:grid-cols-3 gap-6">
            <div>
              <span className="text-[10px] font-bold text-gray-400 uppercase">Vehicle & Driver</span>
              <div className="text-base font-bold text-[#18221E] mt-0.5">{shipment.vehicleNumber}</div>
              <div className="text-xs text-gray-600">{shipment.driverName} ({shipment.driverPhone})</div>
              <div className="text-xs text-blue-700 font-semibold mt-1">Reefer Container Temp: {shipment.currentTempC}°C</div>
            </div>

            <div>
              <span className="text-[10px] font-bold text-gray-400 uppercase">Destination Depot</span>
              <div className="text-base font-bold text-[#18221E] mt-0.5">{shipment.destination}</div>
              <div className="text-xs text-gray-600">Buyer: {shipment.buyerName}</div>
              <div className="text-xs text-gray-500 mt-1">ETA: {shipment.estimatedDeliveryTime}</div>
            </div>

            <div>
              <span className="text-[10px] font-bold text-gray-400 uppercase">Aggregated Payload</span>
              <div className="text-base font-black text-emerald-800 mt-0.5">{shipment.totalKg} kg</div>
              <div className="text-xs text-gray-600">{shipment.cropName} (Aggregated from {shipment.farmerCount} farmers)</div>
              <div className="text-xs text-gray-500 mt-1">Shared transit cost: ₹2.50 / kg</div>
            </div>
          </div>

          {/* Shipment Transit Timeline */}
          <div className="space-y-3">
            <h4 className="text-xs font-bold uppercase tracking-wider text-gray-500">
              Cold-Chain Shipment Timeline
            </h4>
            <div className="grid grid-cols-1 sm:grid-cols-6 gap-2 text-xs">
              {[
                { label: 'Preparing Crates', done: true },
                { label: 'Aggregating Lots', done: true },
                { label: 'Loaded & Sealed', done: true },
                { label: 'In Reefer Transit', done: true, active: true },
                { label: 'Depot Intake Scan', done: false },
                { label: 'Settled to Farmers', done: false },
              ].map((step, idx) => (
                <div
                  key={idx}
                  className={`p-3 rounded-xl border text-center transition-all ${
                    step.active
                      ? 'bg-blue-50 border-blue-400 text-blue-900 font-bold ring-2 ring-blue-400/20'
                      : step.done
                      ? 'bg-emerald-50 border-emerald-300 text-emerald-900 font-semibold'
                      : 'bg-gray-50 border-gray-200 text-gray-400'
                  }`}
                >
                  <div className="text-[10px] text-gray-400 uppercase">Stage 0{idx + 1}</div>
                  <div className="mt-1">{step.label}</div>
                </div>
              ))}
            </div>
          </div>
        </div>
      )}

      {/* VIEW 4: PROCESSING ROUTING ("BEST DESTINATION" ENGINE) */}
      {activeHubView === 'processing' && (
        <div className="bg-white rounded-3xl p-6 border border-[#E6E2D8] shadow-sm space-y-6">
          <div>
            <h3 className="text-lg font-black text-[#143626] font-heading">
              Processing Routing & "Best Destination" Engine
            </h3>
            <p className="text-xs text-gray-500">
              Crop-specific value maximization pathways to ensure zero edible produce is wasted.
            </p>
          </div>

          <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
            {/* Tomato Pathway */}
            <div className="p-5 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] space-y-3">
              <h4 className="font-bold text-sm text-[#18221E] font-heading flex items-center justify-between">
                <span>Tomatoes</span>
                <span className="text-[10px] bg-red-100 text-red-800 px-2 py-0.5 rounded">High Perishable</span>
              </h4>
              <div className="space-y-2 text-xs">
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-emerald-800">Grade A:</strong> Fresh Retail Supermarket chains (Bengaluru / Hyderabad) @ ₹18–21/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-blue-800">Grade B:</strong> Regional wholesale mandis & HoReCa institutional buyers @ ₹14–16/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-amber-800">Grade C:</strong> Industrial puree, paste & ketchup manufacturing units @ ₹10–12/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-gray-700">Grade D:</strong> Local bio-gas & micro-compost organic soil conditioning.
                </div>
              </div>
            </div>

            {/* Mango Pathway */}
            <div className="p-5 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] space-y-3">
              <h4 className="font-bold text-sm text-[#18221E] font-heading flex items-center justify-between">
                <span>Mangoes (Banganapalle)</span>
                <span className="text-[10px] bg-amber-100 text-amber-800 px-2 py-0.5 rounded">Seasonal Fruit</span>
              </h4>
              <div className="space-y-2 text-xs">
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-emerald-800">Grade A:</strong> Premium table fruit & export packhouses @ ₹45–60/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-blue-800">Grade B:</strong> Domestic wholesale fruit terminal mandis @ ₹32–38/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-amber-800">Grade C:</strong> Commercial mango pulp & juice extraction plants @ ₹20–24/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-gray-700">Grade D:</strong> Cattle feed supplement & bio-enzymes.
                </div>
              </div>
            </div>

            {/* Banana Pathway */}
            <div className="p-5 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] space-y-3">
              <h4 className="font-bold text-sm text-[#18221E] font-heading flex items-center justify-between">
                <span>Bananas (Grand Naine)</span>
                <span className="text-[10px] bg-yellow-100 text-yellow-800 px-2 py-0.5 rounded">Year-Round</span>
              </h4>
              <div className="space-y-2 text-xs">
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-emerald-800">Grade A:</strong> Modern trade calibrated banana bunches @ ₹16–20/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-blue-800">Grade B:</strong> Regional fruit stalls @ ₹12–14/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-amber-800">Grade C:</strong> Banana chips & puree processing units @ ₹8–10/kg.
                </div>
                <div className="p-2.5 bg-white rounded-xl border border-gray-200">
                  <strong className="text-gray-700">Grade D:</strong> Fiber extraction & vermicompost mulch.
                </div>
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};
