import { Lot, BuyerRequirement } from '../types';

export interface AggregationResult {
  requirementId: string;
  targetQuantityKg: number;
  aggregatedQuantityKg: number;
  remainingQuantityKg: number;
  fulfillmentPct: number;
  farmerCount: number;
  selectedLotIds: string[];
  weightedAvgCostPerKg: number;
  totalOrderValue: number;
  estimatedTransportCost: number;
  estimatedNetHubMargin: number;
  isReadyForDispatch: boolean;
  lotsDetail: {
    lotId: string;
    farmerName: string;
    village: string;
    quantityKg: number;
    grade: string;
    freshnessScore: number;
    contributionPct: number;
  }[];
}

export class AggregationEngine {
  public static calculateAggregation(
    requirement: BuyerRequirement,
    availableLots: Lot[],
    selectedLotIds: string[]
  ): AggregationResult {
    const matchedLots = availableLots.filter((lot) => selectedLotIds.includes(lot.id));

    const aggregatedQuantityKg = matchedLots.reduce((sum, l) => sum + l.quantityKg, 0);
    const remainingQuantityKg = Math.max(0, requirement.quantityNeededKg - aggregatedQuantityKg);
    const fulfillmentPct = Math.min(100, Math.round((aggregatedQuantityKg / requirement.quantityNeededKg) * 100));

    // Unique farmers
    const uniqueFarmers = new Set(matchedLots.map((l) => l.farmerId));
    const farmerCount = uniqueFarmers.size;

    // Standard rate per kg for Grade A farmer base payout is ~₹18
    const baseFarmerPayoutPerKg = requirement.gradeRequired === 'A' ? 18 : 14;
    const weightedAvgCostPerKg = baseFarmerPayoutPerKg;

    const totalOrderValue = aggregatedQuantityKg * requirement.offeredPricePerKg;
    const totalFarmerPayout = aggregatedQuantityKg * baseFarmerPayoutPerKg;
    const estimatedTransportCost = Math.round(aggregatedQuantityKg * 2.5); // ₹2.5/kg shared transit
    const estimatedNetHubMargin = totalOrderValue - totalFarmerPayout - estimatedTransportCost;

    const isReadyForDispatch = aggregatedQuantityKg >= requirement.quantityNeededKg * 0.95; // 95%+ filled

    const lotsDetail = matchedLots.map((lot) => ({
      lotId: lot.id,
      farmerName: lot.farmerName,
      village: lot.village,
      quantityKg: lot.quantityKg,
      grade: lot.grade,
      freshnessScore: lot.freshnessScore,
      contributionPct: Number(((lot.quantityKg / (aggregatedQuantityKg || 1)) * 100).toFixed(1)),
    }));

    return {
      requirementId: requirement.id,
      targetQuantityKg: requirement.quantityNeededKg,
      aggregatedQuantityKg,
      remainingQuantityKg,
      fulfillmentPct,
      farmerCount,
      selectedLotIds,
      weightedAvgCostPerKg,
      totalOrderValue,
      estimatedTransportCost,
      estimatedNetHubMargin,
      isReadyForDispatch,
      lotsDetail,
    };
  }
}
