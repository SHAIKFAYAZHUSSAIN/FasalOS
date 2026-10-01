export type Role = 'landing' | 'farmer' | 'operator' | 'hub' | 'buyer' | 'admin';

export type Language = 'en' | 'te' | 'hi' | 'ta' | 'kn';

export type Grade = 'A' | 'B' | 'C' | 'D';

export type LotStatus = 
  | 'harvested'
  | 'received'
  | 'graded'
  | 'stored'
  | 'matched'
  | 'dispatched'
  | 'delivered'
  | 'settled';

export interface TimelineEvent {
  stage: LotStatus;
  label: string;
  timestamp: string;
  location?: string;
  notes?: string;
}

export interface QualityAssessment {
  overallGrade: Grade;
  confidence: number; // e.g. 0.91 (91%)
  colorScore: number; // 0-100
  maturityScore: number; // 0-100
  sizeUniformityScore: number; // 0-100
  defectRatePct: number; // e.g. 4.2%
  bruisingPct: number; // e.g. 2.1%
  observations: string[];
  imageUrl?: string;
  assessedAt: string;
  operatorConfirmed: boolean;
  operatorNotes?: string;
  overriddenGrade?: Grade;
}

export interface Lot {
  id: string; // e.g. 'LOT-FOS-20481'
  farmerId: string;
  farmerName: string;
  farmerPhone: string;
  village: string;
  cropId: string;
  cropName: string;
  variety: string;
  quantityKg: number;
  grade: Grade;
  harvestTimestamp: string;
  intakeTimestamp: string;
  coldRoomId: string;
  storageSlot: string;
  freshnessScore: number; // 0 - 100
  commercialShelfLifeHours: number;
  initialShelfLifeHours: number;
  recommendedAction: string;
  status: LotStatus;
  quality: QualityAssessment;
  timeline: TimelineEvent[];
  qrCodeUrl?: string;
}

export interface Farmer {
  id: string;
  name: string;
  phone: string;
  village: string;
  taluk: string;
  district: string;
  state: string;
  registeredDate: string;
  cropsGrown: string[];
  totalProduceSoldKg: number;
  totalEarnings: number;
  avoidedLossAmount: number;
  activeLotsCount: number;
  avatarUrl?: string;
}

export interface Crop {
  id: string;
  name: string;
  regionalNames: Record<Language, string>;
  category: 'Vegetable' | 'Fruit' | 'Perishable' | 'Semi-perishable';
  varieties: string[];
  optimalTempC: { min: number; max: number };
  optimalHumidityPct: { min: number; max: number };
  baselineAmbientShelfLifeDays: number;
  baselineColdStorageShelfLifeDays: number;
  processingPathways: {
    gradeA: string;
    gradeB: string;
    gradeC: string;
    gradeD: string;
  };
  sampleImage: string;
}

export interface ColdRoom {
  id: string;
  name: string;
  hubName: string;
  currentTempC: number;
  targetTempC: number;
  currentHumidityPct: number;
  targetHumidityPct: number;
  capacityKg: number;
  occupiedKg: number;
  thermalReserveMinutes: number; // e.g. 380 min = 6h 20m
  solarContributionPct: number; // e.g. 74%
  energyTodayKwh: number;
  solarGeneratedTodayKwh: number;
  gridConsumedTodayKwh: number;
  doorOpeningsToday: number;
  coolingStatus: 'Active' | 'Eco Mode' | 'Thermal Hold' | 'Defrosting';
  status: 'healthy' | 'warning' | 'alert';
}

export interface MarketPrice {
  id: string;
  marketName: string;
  location: string;
  distanceKm: number;
  transitHours: number;
  cropId: string;
  grade: Grade;
  currentPricePerKg: number;
  transportCostPerKg: number;
  handlingCostPerKg: number;
  expectedNetPerKg: number;
  demandLevel: 'High' | 'Medium' | 'Moderate' | 'Low';
  buyerType: 'Retail Chain' | 'Wholesale Mandi' | 'Food Processor' | 'Export Hub';
  freshnessMinRequired: number; // e.g. 85
  priceTrend: 'up' | 'stable' | 'down';
  trendPct: number;
}

export interface BuyerRequirement {
  id: string;
  buyerName: string;
  companyName: string;
  buyerType: 'Retail Chain' | 'Wholesale' | 'Food Processor' | 'Exporter';
  cropId: string;
  cropName: string;
  gradeRequired: Grade;
  quantityNeededKg: number;
  quantityMatchedKg: number;
  destination: string;
  offeredPricePerKg: number;
  deliveryDate: string;
  status: 'open' | 'partially_matched' | 'fully_aggregated' | 'dispatched' | 'fulfilled';
  matchedLotIds: string[];
}

export interface Shipment {
  id: string;
  requirementId: string;
  buyerName: string;
  destination: string;
  cropName: string;
  totalKg: number;
  farmerCount: number;
  vehicleNumber: string;
  driverName: string;
  driverPhone: string;
  status: 'preparing' | 'aggregating' | 'ready_for_pickup' | 'in_transit' | 'delivered' | 'settled';
  departureTime: string;
  estimatedDeliveryTime: string;
  currentTempC: number;
  transportCostTotal: number;
}

export interface Settlement {
  id: string;
  lotId: string;
  farmerId: string;
  farmerName: string;
  cropName: string;
  quantityKg: number;
  ratePerKg: number;
  grossAmount: number;
  storageServiceFee: number;
  transportFee: number;
  platformFee: number;
  netPayout: number;
  status: 'pending' | 'processing' | 'settled';
  settlementDate: string;
  paymentReference: string;
  paymentMode: 'UPI' | 'Direct Bank Transfer' | 'Aadhaar Enabled Payment';
}

export interface Alert {
  id: string;
  category: 'shelflife' | 'coldroom' | 'buyer' | 'inventory';
  severity: 'info' | 'warning' | 'critical';
  title: string;
  message: string;
  timestamp: string;
  lotId?: string;
  read: boolean;
  actionLabel?: string;
}

export interface HubImpactMetrics {
  farmersServed: number;
  produceHandledTonnes: number;
  postHarvestLossAvoidedPct: number;
  farmerNetRealizationUpliftPct: number;
  foodWasteKgRecovered: number;
  solarEnergyContributionPct: number;
  b2bOrdersFulfilled: number;
  hubUtilizationPct: number;
  totalFarmerPayoutsInr: number;
  grossRevenueInr: number;
}
