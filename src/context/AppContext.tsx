import React, { createContext, useContext, useState, useEffect } from 'react';
import confetti from 'canvas-confetti';
import {
  Role,
  Lot,
  ColdRoom,
  BuyerRequirement,
  Shipment,
  Settlement,
  Alert,
  HubImpactMetrics,
  Grade,
  QualityAssessment,
} from '../types';
import {
  MOCK_FARMERS,
  MOCK_CROPS,
  MOCK_COLD_ROOMS,
  MOCK_LOTS,
  MOCK_MARKET_PRICES,
  MOCK_BUYER_REQUIREMENTS,
  MOCK_SHIPMENT,
  MOCK_SETTLEMENT,
  MOCK_ALERTS,
  MOCK_HUB_IMPACT,
} from '../data/mockData';
import { OfflineService } from '../services/OfflineService';

interface AppContextType {
  // Navigation & Role
  currentRole: Role;
  setCurrentRole: (role: Role) => void;
  activeTab: string;
  setActiveTab: (tab: string) => void;

  // Data
  lots: Lot[];
  farmers: typeof MOCK_FARMERS;
  crops: typeof MOCK_CROPS;
  coldRooms: ColdRoom[];
  marketPrices: typeof MOCK_MARKET_PRICES;
  buyerRequirements: BuyerRequirement[];
  shipment: Shipment;
  settlement: Settlement;
  alerts: Alert[];
  impactMetrics: HubImpactMetrics;

  // Offline
  offlineMode: boolean;
  setOfflineMode: (enabled: boolean) => void;
  offlineDraftsCount: number;
  triggerSync: () => void;

  // Modals & Active Selections
  showCopilotModal: boolean;
  setShowCopilotModal: (show: boolean) => void;
  copilotLot: Lot | null;
  openCopilotForLot: (lot: Lot) => void;

  showReceiptModal: boolean;
  setShowReceiptModal: (show: boolean) => void;
  receiptLot: Lot | null;
  openReceiptForLot: (lot: Lot) => void;

  // Actions
  addNewLotFromIntake: (lotData: {
    farmerId: string;
    farmerName: string;
    cropId: string;
    cropName: string;
    variety: string;
    quantityKg: number;
    grade: Grade;
    quality: QualityAssessment;
    coldRoomId: string;
    storageSlot: string;
  }) => Lot;

  aggregateLotsForRequirement: (requirementId: string, lotIds: string[]) => void;
  dispatchShipment: (requirementId: string) => void;
  markAlertAsRead: (alertId: string) => void;

  // 3-Minute Interactive Demo Tour
  demoActive: boolean;
  demoStep: number;
  startDemoTour: () => void;
  nextDemoStep: () => void;
  prevDemoStep: () => void;
  jumpToDemoStep: (step: number) => void;
  endDemoTour: () => void;
}

const AppContext = createContext<AppContextType | undefined>(undefined);

export const AppProvider: React.FC<{ children: React.ReactNode }> = ({ children }) => {
  const [currentRole, setCurrentRole] = useState<Role>('landing');
  const [activeTab, setActiveTab] = useState<string>('home');

  const [lots, setLots] = useState<Lot[]>(MOCK_LOTS);
  const [coldRooms] = useState<ColdRoom[]>(MOCK_COLD_ROOMS);
  const [buyerRequirements, setBuyerRequirements] = useState<BuyerRequirement[]>(MOCK_BUYER_REQUIREMENTS);
  const [shipment, setShipment] = useState<Shipment>(MOCK_SHIPMENT);
  const [settlement, setSettlement] = useState<Settlement>(MOCK_SETTLEMENT);
  const [alerts, setAlerts] = useState<Alert[]>(MOCK_ALERTS);
  const [impactMetrics, setImpactMetrics] = useState<HubImpactMetrics>(MOCK_HUB_IMPACT);

  const [offlineMode, setOfflineMode] = useState<boolean>(false);
  const [offlineDraftsCount, setOfflineDraftsCount] = useState<number>(0);

  const [showCopilotModal, setShowCopilotModal] = useState<boolean>(false);
  const [copilotLot, setCopilotLot] = useState<Lot | null>(MOCK_LOTS[0]);

  const [showReceiptModal, setShowReceiptModal] = useState<boolean>(false);
  const [receiptLot, setReceiptLot] = useState<Lot | null>(MOCK_LOTS[0]);

  // Demo tour state
  const [demoActive, setDemoActive] = useState<boolean>(false);
  const [demoStep, setDemoStep] = useState<number>(1);

  // Sync draft counts
  useEffect(() => {
    setOfflineDraftsCount(OfflineService.getDrafts().filter((d) => !d.synced).length);
  }, []);

  const triggerSync = () => {
    const result = OfflineService.syncAllDrafts();
    setOfflineDraftsCount(result.remainingCount);
    // Add success alert
    setAlerts((prev) => [
      {
        id: `ALT-SYNC-${Date.now()}`,
        category: 'inventory',
        severity: 'info',
        title: 'Offline Drafts Synced',
        message: `Successfully synchronized ${result.syncedCount} offline produce intakes with Kurnool Hub.`,
        timestamp: 'Just now',
        read: false,
      },
      ...prev,
    ]);
  };

  const openCopilotForLot = (lot: Lot) => {
    setCopilotLot(lot);
    setShowCopilotModal(true);
  };

  const openReceiptForLot = (lot: Lot) => {
    setReceiptLot(lot);
    setShowReceiptModal(true);
  };

  const markAlertAsRead = (alertId: string) => {
    setAlerts((prev) => prev.map((a) => (a.id === alertId ? { ...a, read: true } : a)));
  };

  const addNewLotFromIntake = (params: {
    farmerId: string;
    farmerName: string;
    cropId: string;
    cropName: string;
    variety: string;
    quantityKg: number;
    grade: Grade;
    quality: QualityAssessment;
    coldRoomId: string;
    storageSlot: string;
  }): Lot => {
    const newLotId = `LOT-FOS-${Math.floor(20500 + Math.random() * 900)}`;
    const nowIso = new Date().toISOString();

    const newLot: Lot = {
      id: newLotId,
      farmerId: params.farmerId,
      farmerName: params.farmerName,
      farmerPhone: '+91 94401 23456',
      village: 'Nandikotkur',
      cropId: params.cropId,
      cropName: params.cropName,
      variety: params.variety,
      quantityKg: params.quantityKg,
      grade: params.grade,
      harvestTimestamp: nowIso,
      intakeTimestamp: nowIso,
      coldRoomId: params.coldRoomId,
      storageSlot: params.storageSlot,
      freshnessScore: 92,
      commercialShelfLifeHours: 86,
      initialShelfLifeHours: 336,
      recommendedAction: 'Peak condition. Optimal commercial window 3–5 days.',
      status: 'stored',
      quality: params.quality,
      timeline: [
        { stage: 'harvested', label: 'Harvested in field', timestamp: 'Morning, 06:40 AM' },
        { stage: 'received', label: `Weighed & Received (${params.quantityKg} kg)`, timestamp: 'Today, 08:30 AM' },
        { stage: 'graded', label: `AI Graded & Confirmed Grade ${params.grade}`, timestamp: 'Today, 08:45 AM' },
        { stage: 'stored', label: `Placed in ${params.coldRoomId === 'CR-01' ? 'Cold Room A' : 'Cold Room B'}`, timestamp: 'Today, 09:00 AM' },
      ],
      qrCodeUrl: `https://api.qrserver.com/v1/create-qr-code/?size=160x160&data=${newLotId}-${params.farmerName}-${params.quantityKg}KG`,
    };

    setLots((prev) => [newLot, ...prev]);

    // Update hub impact metrics
    setImpactMetrics((prev) => ({
      ...prev,
      produceHandledTonnes: Number((prev.produceHandledTonnes + params.quantityKg / 1000).toFixed(1)),
      hubUtilizationPct: Math.min(95, prev.hubUtilizationPct + 1),
    }));

    if (offlineMode) {
      OfflineService.saveDraft('produce_intake', newLot);
      setOfflineDraftsCount((c) => c + 1);
    }

    return newLot;
  };

  const aggregateLotsForRequirement = (requirementId: string, lotIds: string[]) => {
    setBuyerRequirements((prev) =>
      prev.map((req) => {
        if (req.id === requirementId) {
          const matchedKg = 10000;
          return {
            ...req,
            status: 'fully_aggregated',
            quantityMatchedKg: matchedKg,
            matchedLotIds: Array.from(new Set([...req.matchedLotIds, ...lotIds])),
          };
        }
        return req;
      })
    );

    // Update lots status to matched
    setLots((prev) =>
      prev.map((lot) => {
        if (lotIds.includes(lot.id)) {
          return {
            ...lot,
            status: 'matched',
            timeline: [
              ...lot.timeline,
              { stage: 'matched', label: 'Allocated to Metro Fresh Retail Order #REQ-1048', timestamp: 'Just now' },
            ],
          };
        }
        return lot;
      })
    );

    confetti({
      particleCount: 80,
      spread: 60,
      origin: { y: 0.6 },
      colors: ['#1B4332', '#52B788', '#F59E0B'],
    });
  };

  const dispatchShipment = (requirementId: string) => {
    setShipment((prev) => ({
      ...prev,
      requirementId,
      status: 'in_transit',
      totalKg: 10000,
      farmerCount: 8,
      departureTime: 'Just Now',
      estimatedDeliveryTime: 'Tomorrow 05:00 AM',
    }));

    setBuyerRequirements((prev) =>
      prev.map((req) => (req.id === requirementId ? { ...req, status: 'dispatched' } : req))
    );

    // Also update settlement
    setSettlement((prev) => ({
      ...prev,
      status: 'settled',
      settlementDate: new Date().toLocaleDateString('en-IN'),
    }));

    confetti({
      particleCount: 120,
      spread: 90,
      origin: { y: 0.5 },
      colors: ['#2D6A4F', '#40916C', '#D97706', '#E9C46A'],
    });
  };

  // 3-Minute Demo Tour Stepper
  const startDemoTour = () => {
    setDemoActive(true);
    setDemoStep(1);
    setCurrentRole('farmer');
  };

  const nextDemoStep = () => {
    if (demoStep >= 10) {
      endDemoTour();
      return;
    }
    const next = demoStep + 1;
    jumpToDemoStep(next);
  };

  const prevDemoStep = () => {
    if (demoStep <= 1) return;
    const prev = demoStep - 1;
    jumpToDemoStep(prev);
  };

  const jumpToDemoStep = (step: number) => {
    setDemoStep(step);
    // Automatically transition to the appropriate role and screen for the demo step
    if (step === 1) {
      setCurrentRole('farmer');
      setActiveTab('home');
    } else if (step === 2 || step === 3 || step === 4) {
      setCurrentRole('operator');
      setActiveTab('intake');
    } else if (step === 5) {
      setCurrentRole('hub');
      setActiveTab('coldroom');
    } else if (step === 6) {
      setCurrentRole('farmer');
      setActiveTab('produce');
      setCopilotLot(MOCK_LOTS[0]);
      setShowCopilotModal(true);
    } else if (step === 7) {
      setShowCopilotModal(false);
      setCurrentRole('buyer');
      setActiveTab('marketplace');
    } else if (step === 8) {
      setCurrentRole('buyer');
      setActiveTab('aggregate');
    } else if (step === 9) {
      setCurrentRole('hub');
      setActiveTab('logistics');
    } else if (step === 10) {
      setCurrentRole('farmer');
      setActiveTab('earnings');
      confetti({
        particleCount: 100,
        spread: 80,
        origin: { y: 0.6 },
        colors: ['#1B4332', '#52B788', '#F59E0B'],
      });
    }
  };

  const endDemoTour = () => {
    setDemoActive(false);
  };

  const value = {
    currentRole,
    setCurrentRole,
    activeTab,
    setActiveTab,
    lots,
    farmers: MOCK_FARMERS,
    crops: MOCK_CROPS,
    coldRooms,
    marketPrices: MOCK_MARKET_PRICES,
    buyerRequirements,
    shipment,
    settlement,
    alerts,
    impactMetrics,
    offlineMode,
    setOfflineMode,
    offlineDraftsCount,
    triggerSync,
    showCopilotModal,
    setShowCopilotModal,
    copilotLot,
    openCopilotForLot,
    showReceiptModal,
    setShowReceiptModal,
    receiptLot,
    openReceiptForLot,
    addNewLotFromIntake,
    aggregateLotsForRequirement,
    dispatchShipment,
    markAlertAsRead,
    demoActive,
    demoStep,
    startDemoTour,
    nextDemoStep,
    prevDemoStep,
    jumpToDemoStep,
    endDemoTour,
  };

  return <AppContext.Provider value={value}>{children}</AppContext.Provider>;
};

export const useApp = (): AppContextType => {
  const context = useContext(AppContext);
  if (!context) {
    throw new Error('useApp must be used within an AppProvider');
  }
  return context;
};
