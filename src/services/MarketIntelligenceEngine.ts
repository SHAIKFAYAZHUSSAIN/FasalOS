import { Grade, MarketPrice } from '../types';

export interface MarketComparisonResult {
  cropName: string;
  quantityKg: number;
  grade: Grade;
  localBaselinePrice: number;
  options: {
    marketName: string;
    location: string;
    distanceKm: number;
    transitHours: number;
    buyerType: string;
    currentPrice: number;
    transportCostPerKg: number;
    handlingCostPerKg: number;
    expectedNetPerKg: number;
    totalExpectedGross: number;
    totalExpectedNet: number;
    netGainVsLocalTotal: number;
    demandLevel: 'High' | 'Medium' | 'Moderate' | 'Low';
    freshnessSufficient: boolean;
  }[];
  recommendedOption: string;
  recommendedExplanation: string;
  confidenceScorePct: number;
  assumptions: string[];
  calculatedAt: string;
}

export class MarketIntelligenceEngine {
  public static analyzeOptions(params: {
    cropId: string;
    cropName: string;
    quantityKg: number;
    grade: Grade;
    freshnessScore: number;
    marketPrices: MarketPrice[];
  }): MarketComparisonResult {
    const { cropName, quantityKg, grade, freshnessScore, marketPrices } = params;

    // Filter relevant prices
    const relevantMarkets = marketPrices.filter((m) => m.grade === grade);

    const localMandi = relevantMarkets.find((m) => m.distanceKm <= 20) || relevantMarkets[0];
    const localBaselinePrice = localMandi ? localMandi.currentPricePerKg : 14;

    const options = relevantMarkets.map((market) => {
      const gross = market.currentPricePerKg * quantityKg;
      const totalTransport = market.transportCostPerKg * quantityKg;
      const totalHandling = market.handlingCostPerKg * quantityKg;
      const totalNet = gross - totalTransport - totalHandling;
      const localGross = localBaselinePrice * quantityKg;
      const netGain = totalNet - localGross;

      return {
        marketName: market.marketName,
        location: market.location,
        distanceKm: market.distanceKm,
        transitHours: market.transitHours,
        buyerType: market.buyerType,
        currentPrice: market.currentPricePerKg,
        transportCostPerKg: market.transportCostPerKg,
        handlingCostPerKg: market.handlingCostPerKg,
        expectedNetPerKg: market.expectedNetPerKg,
        totalExpectedGross: gross,
        totalExpectedNet: totalNet,
        netGainVsLocalTotal: netGain,
        demandLevel: market.demandLevel,
        freshnessSufficient: freshnessScore >= market.freshnessMinRequired,
      };
    });

    // Sort by expected net per kg descending
    options.sort((a, b) => b.expectedNetPerKg - a.expectedNetPerKg);

    const bestOption = options.find((opt) => opt.freshnessSufficient) || options[0];

    const recommendedOption = bestOption.marketName;
    const recommendedExplanation = `${bestOption.marketName} currently shows the highest expected net realization (₹${bestOption.expectedNetPerKg.toFixed(2)}/kg vs ₹${localBaselinePrice.toFixed(2)}/kg local mandi). For your ${quantityKg} kg batch, this represents an estimated net uplift of ₹${Math.max(0, bestOption.netGainVsLocalTotal).toLocaleString('en-IN')}, subject to buyer booking and reefer transit.`;

    return {
      cropName,
      quantityKg,
      grade,
      localBaselinePrice,
      options,
      recommendedOption,
      recommendedExplanation,
      confidenceScorePct: 89,
      assumptions: [
        'Simulated reefer transport cost shared across aggregated 8+ tonne load.',
        'Produce freshness remains above 85/100 threshold during transit.',
        'Buyer accepts Grade A delivery without rejection penalty.',
        'Payment settled via direct bank transfer within 24 hours of delivery.',
      ],
      calculatedAt: new Date().toLocaleTimeString('en-IN', { hour: '2-digit', minute: '2-digit' }),
    };
  }
}
