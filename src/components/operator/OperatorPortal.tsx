import React, { useState } from 'react';
import { useApp } from '../../context/AppContext';
import { useTranslation } from '../../locales/i18n';
import { QualityGradingEngine } from '../../services/QualityGradingEngine';
import { Grade, QualityAssessment } from '../../types';
import {
  Store,
  User,
  Scale,
  Calendar,
  Camera,
  Sparkles,
  CheckCircle2,
  QrCode,
  Warehouse,
  ArrowRight,
  ArrowLeft,
  ShieldCheck,
  Search,
  Scan,
  RefreshCw,
  PlusCircle,
  FileText,
  Clock,
  WifiOff,
  Printer,
  ChevronRight,
} from 'lucide-react';

export const OperatorPortal: React.FC = () => {
  const {
    farmers,
    crops,
    coldRooms,
    lots,
    addNewLotFromIntake,
    openReceiptForLot,
    offlineMode,
    offlineDraftsCount,
    triggerSync,
  } = useApp();
  const { t } = useTranslation();

  // Wizard step state (1 to 10)
  const [currentStep, setCurrentStep] = useState<number>(1);

  // Form State
  const [selectedFarmerId, setSelectedFarmerId] = useState<string>(farmers[0].id); // Lakshmi Devi
  const [selectedCropId, setSelectedCropId] = useState<string>('tomato');
  const [quantityKg, setQuantityKg] = useState<number>(250);
  const [harvestDate, setHarvestDate] = useState<string>('Today, 06:40 AM');
  const [sampleImagePreset, setSampleImagePreset] = useState<'premium_a' | 'wholesale_b' | 'processing_c'>('premium_a');

  // AI Assessment State
  const [isScanning, setIsScanning] = useState<boolean>(false);
  const [assessment, setAssessment] = useState<QualityAssessment>(() =>
    QualityGradingEngine.assessQuality({ cropId: 'tomato', simulatedPreset: 'premium_a' })
  );
  const [confirmedGrade, setConfirmedGrade] = useState<Grade>('A');
  const [operatorNotes, setOperatorNotes] = useState<string>('Grade A confirmed. Firm texture, uniform caliber, clean crates.');

  // Storage Assignment
  const [selectedColdRoomId, setSelectedColdRoomId] = useState<string>('CR-01');
  const [storageSlot, setStorageSlot] = useState<string>('Bay A-04 · Crate Rack 2');

  // Success state
  const [createdLotId, setCreatedLotId] = useState<string | null>(null);

  const selectedFarmer = farmers.find((f) => f.id === selectedFarmerId) || farmers[0];
  const selectedCrop = crops.find((c) => c.id === selectedCropId) || crops[0];

  const handleRunAiScan = () => {
    setIsScanning(true);
    setTimeout(() => {
      const result = QualityGradingEngine.assessQuality({
        cropId: selectedCropId,
        simulatedPreset: sampleImagePreset,
      });
      setAssessment(result);
      setConfirmedGrade(result.overallGrade);
      setIsScanning(false);
    }, 1200);
  };

  const handleFinalSubmit = () => {
    const newLot = addNewLotFromIntake({
      farmerId: selectedFarmer.id,
      farmerName: selectedFarmer.name,
      cropId: selectedCrop.id,
      cropName: selectedCrop.name,
      variety: selectedCrop.varieties[0] || 'Standard',
      quantityKg,
      grade: confirmedGrade,
      quality: {
        ...assessment,
        overallGrade: confirmedGrade,
        operatorConfirmed: true,
        operatorNotes,
      },
      coldRoomId: selectedColdRoomId,
      storageSlot,
    });

    setCreatedLotId(newLot.id);
    setCurrentStep(10);
  };

  const resetWizard = () => {
    setCurrentStep(1);
    setCreatedLotId(null);
    setQuantityKg(250);
  };

  return (
    <div className="max-w-4xl mx-auto px-4 sm:px-6 py-6 space-y-6">
      {/* Header Banner */}
      <div className="p-5 rounded-3xl bg-white border border-[#E6E2D8] shadow-sm flex flex-col sm:flex-row sm:items-center justify-between gap-4">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded-2xl bg-amber-100 text-amber-800 flex items-center justify-center flex-shrink-0">
            <Store className="w-6 h-6" />
          </div>
          <div>
            <div className="flex items-center gap-2">
              <h2 className="text-xl font-black text-[#143626] font-heading tracking-tight">
                {t.operator.portalTitle}
              </h2>
              <span className="text-[10px] font-bold px-2 py-0.5 rounded-full bg-emerald-100 text-emerald-800">
                Hub Active
              </span>
            </div>
            <p className="text-xs text-[#5C6761] font-medium">
              Nandikotkur Village · {t.operator.hubLocation}
            </p>
          </div>
        </div>

        {offlineMode && (
          <div className="flex items-center gap-2 bg-amber-50 text-amber-900 border border-amber-200 px-3 py-1.5 rounded-xl text-xs">
            <WifiOff className="w-4 h-4 text-amber-600 animate-pulse" />
            <span>
              {offlineDraftsCount} drafts saved locally.
            </span>
            <button
              onClick={triggerSync}
              className="ml-1 text-[11px] font-bold text-amber-900 underline hover:text-amber-950"
            >
              Sync Now
            </button>
          </div>
        )}
      </div>

      {/* 10-Step Guided Intake Workflow Container */}
      <div className="bg-white rounded-3xl border border-[#E6E2D8] shadow-sm overflow-hidden">
        {/* Step Indicator Header */}
        <div className="bg-[#FAF9F5] p-4 sm:px-6 border-b border-[#E6E2D8]">
          <div className="flex items-center justify-between text-xs mb-2">
            <span className="font-bold text-[#1B4332] uppercase tracking-wider">
              Step {currentStep} of 10: {
                currentStep === 1 ? t.operator.intakeSteps.step1 :
                currentStep === 2 ? t.operator.intakeSteps.step2 :
                currentStep === 3 ? t.operator.intakeSteps.step3 :
                currentStep === 4 ? t.operator.intakeSteps.step4 :
                currentStep === 5 ? t.operator.intakeSteps.step5 :
                currentStep === 6 ? t.operator.intakeSteps.step6 :
                currentStep === 7 ? t.operator.intakeSteps.step7 :
                currentStep === 8 ? t.operator.intakeSteps.step8 :
                currentStep === 9 ? t.operator.intakeSteps.step9 :
                t.operator.intakeSteps.step10
              }
            </span>
            <span className="text-gray-500 font-medium">{Math.round((currentStep / 10) * 100)}% Complete</span>
          </div>
          <div className="w-full h-1.5 bg-[#E6E2D8] rounded-full overflow-hidden">
            <div
              className="h-full bg-[#1B4332] rounded-full transition-all duration-300"
              style={{ width: `${(currentStep / 10) * 100}%` }}
            />
          </div>
        </div>

        {/* Step Views */}
        <div className="p-6 sm:p-8">
          {/* STEP 1: Select Farmer */}
          {currentStep === 1 && (
            <div className="space-y-4">
              <div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  1. Select Farmer
                </h3>
                <p className="text-xs text-gray-500">{t.operator.selectFarmerPrompt}</p>
              </div>

              <div className="grid grid-cols-1 sm:grid-cols-2 gap-3">
                {farmers.map((farmer) => {
                  const isSelected = selectedFarmerId === farmer.id;
                  return (
                    <div
                      key={farmer.id}
                      onClick={() => setSelectedFarmerId(farmer.id)}
                      className={`p-3.5 rounded-2xl border cursor-pointer transition-all flex items-center justify-between ${
                        isSelected
                          ? 'border-emerald-600 bg-emerald-50/50 shadow-sm ring-1 ring-emerald-600/30'
                          : 'border-[#E6E2D8] hover:bg-[#FAF9F5]'
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <img
                          src={farmer.avatarUrl}
                          alt={farmer.name}
                          className="w-10 h-10 rounded-full object-cover border border-gray-200"
                        />
                        <div>
                          <div className="text-sm font-bold text-[#18221E]">{farmer.name}</div>
                          <div className="text-xs text-gray-500">{farmer.village} · {farmer.phone}</div>
                        </div>
                      </div>
                      {isSelected && <CheckCircle2 className="w-5 h-5 text-emerald-600" />}
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* STEP 2: Select Crop */}
          {currentStep === 2 && (
            <div className="space-y-4">
              <div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  2. Select Harvested Crop
                </h3>
                <p className="text-xs text-gray-500">{t.operator.selectCropPrompt}</p>
              </div>

              <div className="grid grid-cols-2 sm:grid-cols-3 gap-3">
                {crops.map((crop) => {
                  const isSelected = selectedCropId === crop.id;
                  return (
                    <div
                      key={crop.id}
                      onClick={() => setSelectedCropId(crop.id)}
                      className={`p-3 rounded-2xl border cursor-pointer transition-all text-center ${
                        isSelected
                          ? 'border-emerald-600 bg-emerald-50/50 shadow-sm ring-1 ring-emerald-600/30'
                          : 'border-[#E6E2D8] hover:bg-[#FAF9F5]'
                      }`}
                    >
                      <img
                        src={crop.sampleImage}
                        alt={crop.name}
                        className="w-full h-24 object-cover rounded-xl mb-2"
                      />
                      <div className="font-bold text-sm text-[#18221E]">{crop.name}</div>
                      <div className="text-[11px] text-gray-500">{crop.varieties[0]}</div>
                    </div>
                  );
                })}
              </div>
            </div>
          )}

          {/* STEP 3: Enter Quantity (Weigh Produce) */}
          {currentStep === 3 && (
            <div className="space-y-4 max-w-md mx-auto text-center py-4">
              <div className="w-14 h-14 rounded-2xl bg-emerald-100 text-emerald-800 flex items-center justify-center mx-auto">
                <Scale className="w-7 h-7" />
              </div>
              <div>
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  3. Verify & Enter Weight
                </h3>
                <p className="text-xs text-gray-500">{t.operator.enterWeight}</p>
              </div>

              <div className="pt-2">
                <div className="flex items-center justify-center gap-2">
                  <input
                    type="number"
                    value={quantityKg}
                    onChange={(e) => setQuantityKg(Math.max(1, Number(e.target.value)))}
                    className="w-36 text-center text-4xl font-black font-heading border-2 border-emerald-600 rounded-2xl py-2 focus:outline-none focus:ring-4 focus:ring-emerald-500/20"
                  />
                  <span className="text-xl font-bold text-gray-500">kg</span>
                </div>
                <div className="flex justify-center gap-2 mt-3">
                  {[100, 250, 500, 1000].map((preset) => (
                    <button
                      key={preset}
                      onClick={() => setQuantityKg(preset)}
                      className={`px-3 py-1 rounded-lg text-xs font-semibold border ${
                        quantityKg === preset
                          ? 'bg-emerald-600 text-white border-emerald-600'
                          : 'bg-[#FAF9F5] border-[#E0DCD2] text-gray-700'
                      }`}
                    >
                      {preset} kg
                    </button>
                  ))}
                </div>
              </div>

              <div className="p-3 bg-gray-50 rounded-xl text-xs text-gray-500 border border-gray-200">
                Connected to Avery India Electronic Scale #02 · Tare weight deducted (10 standard 25kg crates).
              </div>
            </div>
          )}

          {/* STEP 4: Harvest Date & Time */}
          {currentStep === 4 && (
            <div className="space-y-4 max-w-md mx-auto py-4">
              <div className="text-center">
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  4. Log Harvest Date & Time
                </h3>
                <p className="text-xs text-gray-500">
                  Critical baseline for dynamic shelf-life decay modeling.
                </p>
              </div>

              <div className="space-y-3">
                <div className="p-3.5 rounded-2xl border border-emerald-600 bg-emerald-50/40 flex items-center justify-between">
                  <div className="flex items-center gap-2.5">
                    <Clock className="w-5 h-5 text-emerald-700" />
                    <div>
                      <div className="text-xs font-bold text-[#18221E]">Morning Peak Harvest</div>
                      <div className="text-[11px] text-gray-500">Today, 06:40 AM (2.5 hours elapsed)</div>
                    </div>
                  </div>
                  <CheckCircle2 className="w-5 h-5 text-emerald-600" />
                </div>

                <div className="p-3.5 rounded-2xl border border-gray-200 bg-white flex items-center justify-between cursor-pointer hover:bg-gray-50">
                  <div className="flex items-center gap-2.5">
                    <Calendar className="w-5 h-5 text-gray-400" />
                    <div>
                      <div className="text-xs font-bold text-gray-700">Custom Harvest Timestamp</div>
                      <div className="text-[11px] text-gray-400">Specify field plucking time</div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          )}

          {/* STEP 5: Produce Image Capture */}
          {currentStep === 5 && (
            <div className="space-y-4 max-w-lg mx-auto py-2">
              <div className="text-center">
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  5. Capture Produce Sample Photo
                </h3>
                <p className="text-xs text-gray-500">
                  Camera optical feed for computer-vision quality and defect analysis.
                </p>
              </div>

              {/* Camera Frame Preview */}
              <div className="relative rounded-2xl overflow-hidden border-2 border-emerald-600 bg-gray-900 aspect-video flex items-center justify-center shadow-inner">
                <img
                  src={selectedCrop.sampleImage}
                  alt="Optical Camera Scan"
                  className="w-full h-full object-cover opacity-90"
                />

                {/* Overlaid Scanner Grid */}
                <div className="absolute inset-0 border border-emerald-400/40 pointer-events-none grid grid-cols-3 grid-rows-3">
                  <div className="border-r border-b border-emerald-400/20" />
                  <div className="border-r border-b border-emerald-400/20" />
                  <div className="border-b border-emerald-400/20" />
                  <div className="border-r border-b border-emerald-400/20" />
                  <div className="border-r border-b border-emerald-400/20 flex items-center justify-center">
                    <div className="w-16 h-16 border-2 border-amber-400 rounded-lg animate-ping opacity-30" />
                  </div>
                  <div className="border-b border-emerald-400/20" />
                </div>

                <div className="absolute bottom-2 left-2 right-2 px-3 py-1.5 rounded-lg bg-black/70 backdrop-blur-xs text-white text-[11px] flex items-center justify-between">
                  <span className="flex items-center gap-1.5 font-mono text-emerald-400">
                    <span className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                    HD Macro Optics Ready
                  </span>
                  <span className="text-gray-300">1080p · Auto Caliber</span>
                </div>
              </div>

              {/* Sample simulation picker */}
              <div className="flex items-center justify-between text-xs pt-1">
                <span className="text-gray-500 font-medium">Simulate Sample Condition:</span>
                <div className="flex gap-1.5">
                  <button
                    onClick={() => setSampleImagePreset('premium_a')}
                    className={`px-2 py-1 rounded text-[11px] font-bold ${
                      sampleImagePreset === 'premium_a'
                        ? 'bg-emerald-700 text-white'
                        : 'bg-gray-100 text-gray-700'
                    }`}
                  >
                    Prime Grade A
                  </button>
                  <button
                    onClick={() => setSampleImagePreset('wholesale_b')}
                    className={`px-2 py-1 rounded text-[11px] font-bold ${
                      sampleImagePreset === 'wholesale_b'
                        ? 'bg-amber-600 text-white'
                        : 'bg-gray-100 text-gray-700'
                    }`}
                  >
                    Wholesale B
                  </button>
                  <button
                    onClick={() => setSampleImagePreset('processing_c')}
                    className={`px-2 py-1 rounded text-[11px] font-bold ${
                      sampleImagePreset === 'processing_c'
                        ? 'bg-orange-600 text-white'
                        : 'bg-gray-100 text-gray-700'
                    }`}
                  >
                    Processing C
                  </button>
                </div>
              </div>
            </div>
          )}

          {/* STEP 6: AI Computer Vision Assessment */}
          {currentStep === 6 && (
            <div className="space-y-4 max-w-lg mx-auto py-2">
              <div className="text-center">
                <div className="inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-100 text-emerald-800 text-xs font-bold mb-1">
                  <Sparkles className="w-3.5 h-3.5 text-amber-500" />
                  {t.operator.aiGradingTitle}
                </div>
                <h3 className="text-xl font-black text-[#143626] font-heading">
                  AI Suggested Grade: Grade {assessment.overallGrade}
                </h3>
                <p className="text-xs text-gray-500">
                  Model Confidence: <strong className="text-emerald-700">{Math.round(assessment.confidence * 100)}%</strong>
                </p>
              </div>

              {/* Sensory Breakdown Cards */}
              <div className="grid grid-cols-2 gap-3 text-xs">
                <div className="p-3 rounded-xl bg-[#FAF9F5] border border-[#E6E2D8]">
                  <span className="text-gray-400 text-[10px] font-bold uppercase">{t.operator.colorScore}</span>
                  <div className="text-base font-black text-[#18221E]">{assessment.colorScore}%</div>
                  <div className="text-[10px] text-emerald-700 font-medium">Uniform lycopene hue</div>
                </div>

                <div className="p-3 rounded-xl bg-[#FAF9F5] border border-[#E6E2D8]">
                  <span className="text-gray-400 text-[10px] font-bold uppercase">{t.operator.uniformity}</span>
                  <div className="text-base font-black text-[#18221E]">{assessment.sizeUniformityScore}%</div>
                  <div className="text-[10px] text-emerald-700 font-medium">Caliber 55–65mm standard</div>
                </div>

                <div className="p-3 rounded-xl bg-[#FAF9F5] border border-[#E6E2D8]">
                  <span className="text-gray-400 text-[10px] font-bold uppercase">{t.operator.defectRate}</span>
                  <div className="text-base font-black text-[#18221E]">{assessment.defectRatePct}%</div>
                  <div className="text-[10px] text-emerald-700 font-medium">Within Grade A tolerance (&lt;4%)</div>
                </div>

                <div className="p-3 rounded-xl bg-[#FAF9F5] border border-[#E6E2D8]">
                  <span className="text-gray-400 text-[10px] font-bold uppercase">{t.operator.bruising}</span>
                  <div className="text-base font-black text-[#18221E]">{assessment.bruisingPct}%</div>
                  <div className="text-[10px] text-emerald-700 font-medium">Negligible mechanical press</div>
                </div>
              </div>

              {/* AI Observations Box */}
              <div className="p-3 bg-white rounded-xl border border-gray-200 text-xs space-y-1">
                <span className="text-[10px] font-bold text-gray-400 uppercase">Sensory Observations</span>
                <ul className="text-gray-600 list-disc list-inside space-y-0.5 text-[11px]">
                  {assessment.observations.map((obs, idx) => (
                    <li key={idx}>{obs}</li>
                  ))}
                </ul>
              </div>
            </div>
          )}

          {/* STEP 7: Operator Confirmation & Override */}
          {currentStep === 7 && (
            <div className="space-y-4 max-w-md mx-auto py-2">
              <div className="text-center">
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  7. Operator Confirmation & Override
                </h3>
                <p className="text-xs text-gray-500">
                  AI is an assistant. The village operator holds final authority.
                </p>
              </div>

              <div className="space-y-2">
                <label className="text-xs font-bold text-gray-600">Select Final Grade:</label>
                <div className="grid grid-cols-4 gap-2">
                  {(['A', 'B', 'C', 'D'] as Grade[]).map((g) => (
                    <button
                      key={g}
                      onClick={() => setConfirmedGrade(g)}
                      className={`py-3 rounded-xl font-black text-sm border transition-all ${
                        confirmedGrade === g
                          ? 'bg-[#1B4332] text-white border-[#1B4332] shadow-sm'
                          : 'bg-white border-[#E0DCD2] text-gray-700 hover:bg-[#FAF9F5]'
                      }`}
                    >
                      Grade {g}
                    </button>
                  ))}
                </div>
              </div>

              <div className="space-y-1.5 pt-2">
                <label className="text-xs font-bold text-gray-600">Operator Physical Inspection Notes:</label>
                <textarea
                  value={operatorNotes}
                  onChange={(e) => setOperatorNotes(e.target.value)}
                  rows={2}
                  className="w-full text-xs p-3 rounded-xl border border-[#D5D0C3] focus:outline-none focus:border-emerald-600"
                  placeholder="Record tactile firmness, crate conditions, or specific observations..."
                />
              </div>
            </div>
          )}

          {/* STEP 8: Create Digital Lot Preview */}
          {currentStep === 8 && (
            <div className="space-y-4 max-w-md mx-auto py-2">
              <div className="text-center">
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  8. Create Digital Lot
                </h3>
                <p className="text-xs text-gray-500">
                  Generating cryptographic batch ID for supply-chain traceability.
                </p>
              </div>

              <div className="p-4 rounded-2xl bg-[#FAF9F5] border border-[#E6E2D8] space-y-2.5 text-xs">
                <div className="flex justify-between">
                  <span className="text-gray-500">Farmer:</span>
                  <span className="font-bold text-[#18221E]">{selectedFarmer.name} ({selectedFarmer.village})</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Crop:</span>
                  <span className="font-bold text-[#2D6A4F]">{selectedCrop.name} · {quantityKg} kg</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Confirmed Grade:</span>
                  <span className="font-black text-emerald-800">Grade {confirmedGrade}</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">AI Confidence:</span>
                  <span className="font-semibold text-gray-700">{Math.round(assessment.confidence * 100)}%</span>
                </div>
                <div className="flex justify-between">
                  <span className="text-gray-500">Harvest Log:</span>
                  <span className="font-semibold text-gray-700">{harvestDate}</span>
                </div>
              </div>
            </div>
          )}

          {/* STEP 9: Assign Cold Storage */}
          {currentStep === 9 && (
            <div className="space-y-4 max-w-md mx-auto py-2">
              <div className="text-center">
                <h3 className="text-lg font-bold text-[#18221E] font-heading">
                  9. Assign Cold Storage Location
                </h3>
                <p className="text-xs text-gray-500">
                  Allocate rack or bay inside solar micro-cold room.
                </p>
              </div>

              <div className="space-y-3">
                {coldRooms.map((room) => {
                  const isSelected = selectedColdRoomId === room.id;
                  return (
                    <div
                      key={room.id}
                      onClick={() => setSelectedColdRoomId(room.id)}
                      className={`p-3.5 rounded-2xl border cursor-pointer transition-all flex items-center justify-between ${
                        isSelected
                          ? 'border-emerald-600 bg-emerald-50/50 shadow-sm ring-1 ring-emerald-600/30'
                          : 'border-[#E6E2D8] hover:bg-[#FAF9F5]'
                      }`}
                    >
                      <div className="flex items-center gap-3">
                        <Warehouse className="w-6 h-6 text-blue-600" />
                        <div>
                          <div className="text-sm font-bold text-[#18221E]">{room.name}</div>
                          <div className="text-xs text-gray-500">
                            {room.currentTempC}°C · {room.currentHumidityPct}% Humidity · {room.solarContributionPct}% Solar
                          </div>
                        </div>
                      </div>
                      {isSelected && <CheckCircle2 className="w-5 h-5 text-emerald-600" />}
                    </div>
                  );
                })}
              </div>

              <div className="space-y-1">
                <label className="text-xs font-bold text-gray-600">Assigned Bay / Rack Slot:</label>
                <input
                  type="text"
                  value={storageSlot}
                  onChange={(e) => setStorageSlot(e.target.value)}
                  className="w-full text-xs p-3 rounded-xl border border-[#D5D0C3] focus:outline-none focus:border-emerald-600"
                />
              </div>
            </div>
          )}

          {/* STEP 10: Receipt Generated Success */}
          {currentStep === 10 && (
            <div className="space-y-5 max-w-md mx-auto text-center py-4 animate-in zoom-in-95">
              <div className="w-16 h-16 rounded-full bg-emerald-100 text-emerald-800 flex items-center justify-center mx-auto shadow-sm">
                <CheckCircle2 className="w-9 h-9" />
              </div>

              <div>
                <span className="text-[11px] font-bold uppercase tracking-wider text-emerald-700 bg-emerald-50 px-2.5 py-0.5 rounded-full">
                  Lot Successfully Created & Stored
                </span>
                <h3 className="text-2xl font-black text-[#143626] font-heading mt-1">
                  {createdLotId || 'LOT-FOS-20481'}
                </h3>
                <p className="text-xs text-gray-600 mt-1">
                  {quantityKg} kg {selectedCrop.name} · Grade {confirmedGrade} · {selectedColdRoomId === 'CR-01' ? 'Cold Room A' : 'Cold Room B'}
                </p>
              </div>

              <div className="flex gap-2">
                <button
                  onClick={() => {
                    const createdLot = lots.find((l) => l.id === createdLotId) || lots[0];
                    openReceiptForLot(createdLot);
                  }}
                  className="flex-1 py-3 px-4 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all flex items-center justify-center gap-1.5 shadow-sm"
                >
                  <QrCode className="w-4 h-4" />
                  <span>View Printable Receipt</span>
                </button>

                <button
                  onClick={resetWizard}
                  className="py-3 px-4 rounded-xl border border-gray-300 text-xs font-semibold text-gray-700 hover:bg-gray-50 transition-colors"
                >
                  New Intake
                </button>
              </div>
            </div>
          )}
        </div>

        {/* Wizard Footer Controls */}
        {currentStep < 10 && (
          <div className="p-4 sm:px-6 bg-[#FAF9F5] border-t border-[#E6E2D8] flex items-center justify-between">
            <button
              onClick={() => setCurrentStep((s) => Math.max(1, s - 1))}
              disabled={currentStep === 1}
              className="flex items-center gap-1 px-4 py-2 rounded-xl border border-[#D5D0C3] bg-white text-xs font-semibold text-gray-700 hover:bg-gray-50 disabled:opacity-40 transition-colors"
            >
              <ArrowLeft className="w-3.5 h-3.5" />
              <span>Back</span>
            </button>

            {currentStep === 5 ? (
              <button
                onClick={() => {
                  handleRunAiScan();
                  setCurrentStep(6);
                }}
                disabled={isScanning}
                className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all shadow-sm"
              >
                <Sparkles className="w-3.5 h-3.5 text-amber-300" />
                <span>Run AI Assessment</span>
              </button>
            ) : currentStep === 9 ? (
              <button
                onClick={handleFinalSubmit}
                className="flex items-center gap-1.5 px-6 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all shadow-md shadow-emerald-950/20"
              >
                <CheckCircle2 className="w-3.5 h-3.5" />
                <span>Generate Lot & Receipt</span>
              </button>
            ) : (
              <button
                onClick={() => setCurrentStep((s) => Math.min(10, s + 1))}
                className="flex items-center gap-1.5 px-5 py-2.5 rounded-xl bg-[#1B4332] text-white text-xs font-bold hover:bg-[#2D6A4F] transition-all shadow-sm"
              >
                <span>Continue</span>
                <ArrowRight className="w-3.5 h-3.5" />
              </button>
            )}
          </div>
        )}
      </div>

      {/* Today's Intake Queue Table */}
      <div className="bg-white rounded-3xl border border-[#E6E2D8] shadow-sm p-6 space-y-4">
        <div className="flex items-center justify-between">
          <div>
            <h3 className="text-base font-bold text-[#18221E] font-heading">
              Today's Intake & Active Lots
            </h3>
            <p className="text-xs text-gray-500">Live inventory across Kurnool Hub #04 cold chambers</p>
          </div>
          <span className="text-xs font-bold text-emerald-800 bg-emerald-50 px-2.5 py-1 rounded-full border border-emerald-200">
            {lots.length} Traceable Batches
          </span>
        </div>

        <div className="divide-y divide-gray-100 overflow-x-auto">
          {lots.slice(0, 5).map((lot) => (
            <div
              key={lot.id}
              className="py-3 flex items-center justify-between gap-4 text-xs hover:bg-[#FAF9F5] px-2 rounded-xl transition-colors"
            >
              <div className="flex items-center gap-3">
                <span className="font-mono font-bold text-gray-500 bg-gray-100 px-2 py-0.5 rounded">
                  {lot.id}
                </span>
                <div>
                  <div className="font-bold text-[#18221E]">{lot.farmerName}</div>
                  <div className="text-[11px] text-gray-500">{lot.cropName} · {lot.variety}</div>
                </div>
              </div>

              <div className="flex items-center gap-4">
                <div className="text-right">
                  <div className="font-bold text-[#18221E]">{lot.quantityKg} kg</div>
                  <div className="text-[10px] text-emerald-700 font-semibold">Grade {lot.grade}</div>
                </div>

                <div className="text-right hidden sm:block">
                  <div className="text-gray-500 font-medium">Freshness</div>
                  <div className="font-bold text-emerald-700">{lot.freshnessScore}/100</div>
                </div>

                <button
                  onClick={() => openReceiptForLot(lot)}
                  className="p-1.5 rounded-lg border border-gray-200 text-gray-600 hover:text-[#18221E] hover:bg-gray-100"
                  title="View Receipt"
                >
                  <QrCode className="w-4 h-4" />
                </button>
              </div>
            </div>
          ))}
        </div>
      </div>
    </div>
  );
};
