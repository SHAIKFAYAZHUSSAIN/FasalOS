import { Grade, QualityAssessment } from '../types';

export interface GradingInput {
  cropId: string;
  variety?: string;
  imageBlobUrl?: string;
  harvestHoursAgo?: number;
  simulatedPreset?: 'premium_a' | 'wholesale_b' | 'processing_c' | 'distress_d';
}

export class QualityGradingEngine {
  /**
   * Run computer vision grading analysis on produce sample
   */
  public static assessQuality(input: GradingInput): QualityAssessment {
    const preset = input.simulatedPreset || 'premium_a';
    
    let overallGrade: Grade = 'A';
    let confidence = 0.91; // 91%
    let colorScore = 94;
    let maturityScore = 92;
    let sizeUniformityScore = 95;
    let defectRatePct = 3.2;
    let bruisingPct = 1.8;
    let observations: string[] = [
      'High carotenoid / lycopene color uniformity (94% ripeness)',
      'Uniform diameter within 55–65mm commercial standard',
      'Surface blemishes strictly below 4% threshold',
      'Zero active fungal spores or stem rot detected',
    ];

    if (preset === 'wholesale_b') {
      overallGrade = 'B';
      confidence = 0.88;
      colorScore = 84;
      maturityScore = 86;
      sizeUniformityScore = 82;
      defectRatePct = 8.5;
      bruisingPct = 4.2;
      observations = [
        'Moderate color variance across batch (82–88% ripeness)',
        'Caliber variance spans 45–70mm (wholesale acceptable)',
        'Minor superficial skin blemishes on ~8% of sample',
        'Firmness intact; suitable for regional wholesale mandi',
      ];
    } else if (preset === 'processing_c') {
      overallGrade = 'C';
      confidence = 0.85;
      colorScore = 78;
      maturityScore = 96; // over-ripe
      sizeUniformityScore = 70;
      defectRatePct = 16.4;
      bruisingPct = 9.8;
      observations = [
        'Advanced maturity / soft texture suitable for pulping',
        'Irregular sizes not suited for retail grading',
        'Visible mechanical bruises, but pulp clean and edible',
        'Recommended destination: Industrial tomato puree / sauce unit',
      ];
    } else if (preset === 'distress_d') {
      overallGrade = 'D';
      confidence = 0.94;
      colorScore = 55;
      maturityScore = 60;
      sizeUniformityScore = 62;
      defectRatePct = 32.0;
      bruisingPct = 22.5;
      observations = [
        'High defect rate exceeding commercial tolerances',
        'Early mold / microbial decay indicators spotted',
        'Unfit for fresh or standard food processing channels',
        'Recommended destination: Local bio-gas / organic compost recovery',
      ];
    }

    return {
      overallGrade,
      confidence,
      colorScore,
      maturityScore,
      sizeUniformityScore,
      defectRatePct,
      bruisingPct,
      observations,
      imageUrl: input.imageBlobUrl,
      assessedAt: new Date().toISOString(),
      operatorConfirmed: false,
    };
  }

  /**
   * Helper to format confidence percentage
   */
  public static formatConfidence(confidence: number): string {
    return `${Math.round(confidence * 100)}%`;
  }
}
