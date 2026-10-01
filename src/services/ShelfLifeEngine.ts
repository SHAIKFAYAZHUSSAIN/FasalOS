import { Grade } from '../types';

export interface ShelfLifeEstimate {
  freshnessScore: number; // 0 - 100
  commercialHoursRemaining: number;
  commercialDaysRemaining: number;
  statusLevel: 'peak' | 'good' | 'action_needed' | 'critical';
  recommendedAction: string;
  spoilageRiskPct: number;
  factors: {
    tempImpact: string;
    humidityImpact: string;
    gradeImpact: string;
    harvestElapsedHours: number;
  };
}

export class ShelfLifeEngine {
  /**
   * Calculate dynamic commercial shelf life and freshness score
   */
  public static calculate(params: {
    cropId: string;
    grade: Grade;
    harvestTimestamp: string;
    coldRoomTempC: number;
    coldRoomHumidityPct: number;
  }): ShelfLifeEstimate {
    const { cropId, grade, harvestTimestamp, coldRoomTempC, coldRoomHumidityPct } = params;
    
    // Baseline storage capacity in hours at ideal conditions
    const baselineHoursByCrop: Record<string, number> = {
      tomato: 336, // 14 days
      mango: 504,  // 21 days
      banana: 432, // 18 days
      onion: 1440, // 60 days
      leafy: 168,  // 7 days
    };

    const baselineHours = baselineHoursByCrop[cropId.toLowerCase()] || 240;

    // Elapsed time since harvest
    const harvestDate = new Date(harvestTimestamp);
    const now = new Date();
    const elapsedHours = Math.max(1, (now.getTime() - harvestDate.getTime()) / (1000 * 60 * 60));

    // Temperature degradation factor (ideal cold storage temp is ~8-12°C depending on crop)
    let tempMultiplier = 1.0;
    if (coldRoomTempC > 12) {
      tempMultiplier = 1.35 + (coldRoomTempC - 12) * 0.1;
    } else if (coldRoomTempC < 4 && cropId !== 'leafy') {
      // Chilling injury risk for tropical fruits
      tempMultiplier = 1.2;
    }

    // Humidity factor (ideal ~75-85%)
    let humidityMultiplier = 1.0;
    if (coldRoomHumidityPct < 65) {
      humidityMultiplier = 1.25; // dry air accelerates dehydration
    } else if (coldRoomHumidityPct > 90) {
      humidityMultiplier = 1.15; // condensation risks mold
    }

    // Grade quality degradation factor
    const gradeMultiplierMap: Record<Grade, number> = {
      A: 0.9,  // premium keeps longer
      B: 1.0,
      C: 1.3,  // processing grade decays faster
      D: 1.8,
    };
    const gradeMultiplier = gradeMultiplierMap[grade] || 1.0;

    // Effective elapsed hours adjusted for micro-climate
    const effectiveHoursConsumed = elapsedHours * tempMultiplier * humidityMultiplier * gradeMultiplier;
    const remainingHours = Math.max(0, Math.round(baselineHours - effectiveHoursConsumed));
    const commercialDaysRemaining = Number((remainingHours / 24).toFixed(1));

    // Freshness score calculation (0 - 100)
    let freshnessScore = Math.max(10, Math.min(100, Math.round(100 - (effectiveHoursConsumed / baselineHours) * 85)));
    
    // Status and Action determination
    let statusLevel: 'peak' | 'good' | 'action_needed' | 'critical' = 'peak';
    let recommendedAction = 'Maintain standard solar cold storage parameters.';
    let spoilageRiskPct = 3.2;

    if (freshnessScore >= 88) {
      statusLevel = 'peak';
      recommendedAction = 'Produce in peak condition. Target premium Grade A retail chains for maximum net realization.';
      spoilageRiskPct = 2.1;
    } else if (freshnessScore >= 75) {
      statusLevel = 'good';
      recommendedAction = 'Consider selling within 48–72 hours to preserve Grade A premium status.';
      spoilageRiskPct = 5.8;
    } else if (freshnessScore >= 60) {
      statusLevel = 'action_needed';
      recommendedAction = 'Priority dispatch required within 24–36 hours. Match with wholesale or quick-turn buyers.';
      spoilageRiskPct = 14.5;
    } else {
      statusLevel = 'critical';
      recommendedAction = 'Immediate routing to food processing (puree/pulp) or quick clearance to prevent total value loss.';
      spoilageRiskPct = 29.4;
    }

    return {
      freshnessScore,
      commercialHoursRemaining: remainingHours,
      commercialDaysRemaining,
      statusLevel,
      recommendedAction,
      spoilageRiskPct,
      factors: {
        tempImpact: coldRoomTempC <= 10 ? 'Optimal (8.2°C)' : 'Elevated temperature',
        humidityImpact: coldRoomHumidityPct >= 70 ? 'Controlled (78%)' : 'Low humidity',
        gradeImpact: `Grade ${grade} baseline stability`,
        harvestElapsedHours: Math.round(elapsedHours),
      }
    };
  }
}
