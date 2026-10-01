import 'package:flutter/foundation.dart';
import '../models/produce_lot.dart';
import '../models/market_channel.dart';
import '../models/solar_metrics.dart';
import '../models/settlement.dart';
import '../models/buyer_order_model.dart';
import 'demo_data.dart';

class ConsolidatedBatch {
  final String batchId; // e.g. 'BAT-500-TOM'
  final String cropType;
  final String grade;
  final double totalWeightKg;
  final List<ProduceLot> memberLots;
  final DateTime createdAt;
  bool isDispatched;
  bool isDelivered;
  bool isSettled;

  ConsolidatedBatch({
    required this.batchId,
    required this.cropType,
    required this.grade,
    required this.totalWeightKg,
    required this.memberLots,
    required this.createdAt,
    this.isDispatched = false,
    this.isDelivered = false,
    this.isSettled = false,
  });
}

class FasalState extends ChangeNotifier {
  List<ProduceLot> _lots = [];
  SolarTelemetry _solar = DemoData.getInitialSolar();
  List<MarketOption> _marketOptions = DemoData.getMarketOptions();
  List<SettlementRecord> _settlements = DemoData.getInitialSettlements();
  List<BuyerOrder> _buyerOrders = [];
  
  final Set<String> _selectedLotIdsForAggregation = {};
  ConsolidatedBatch? _activeBatch;

  bool _isOffline = false;
  int _pendingSyncQueue = 0;
  bool _isSyncing = false;

  // Selected Lot for deep modal inspection
  ProduceLot? _selectedLotForDetail;

  FasalState() {
    _initData();
  }

  void _initData() {
    _lots = DemoData.getInitialLots();
    _solar = DemoData.getInitialSolar();
    _marketOptions = DemoData.getMarketOptions();
    _settlements = DemoData.getInitialSettlements();
    _buyerOrders = [
      BuyerOrder(
        orderId: 'ORD-7819',
        buyerName: 'FreshMart Supermarkets DC',
        buyerLocation: 'Bengaluru Distribution Center',
        cropType: 'Country Tomatoes',
        requiredGrade: 'Grade A+',
        requestedQuantityKg: 500.0,
        agreedRatePerKg: 32.0,
        totalOrderAmount: 16000.0,
        contributingLotIds: ['FOS-20481', 'FOS-20482', 'FOS-20483'],
        status: BuyerOrderStatus.delivered,
        orderTimestamp: DateTime.now().subtract(const Duration(hours: 6)),
        vehicleNumber: 'AP-21-TJ-4491 (Solar Reefer)',
        transportTemp: 11.6,
        progressFraction: 1.0,
      ),
    ];
  }

  // Getters
  List<ProduceLot> get lots => List.unmodifiable(_lots);
  SolarTelemetry get solar => _solar;
  List<MarketOption> get marketOptions => List.unmodifiable(_marketOptions);
  List<SettlementRecord> get settlements => List.unmodifiable(_settlements);
  List<BuyerOrder> get buyerOrders => List.unmodifiable(_buyerOrders);
  Set<String> get selectedLotIdsForAggregation => Set.unmodifiable(_selectedLotIdsForAggregation);
  ConsolidatedBatch? get activeBatch => _activeBatch;
  bool get isOffline => _isOffline;
  int get pendingSyncQueue => _pendingSyncQueue;
  bool get isSyncing => _isSyncing;
  ProduceLot? get selectedLotForDetail => _selectedLotForDetail;

  double get totalStoredProduceKg =>
      _lots.fold(0.0, (acc, item) => acc + item.quantityKg);

  double get totalFarmerEarnings =>
      _settlements.fold(0.0, (acc, s) => acc + s.netFarmerPayout);

  int get activeLotCount => _lots.length;

  void selectLotForDetail(ProduceLot? lot) {
    _selectedLotForDetail = lot;
    notifyListeners();
  }

  // Signature Interaction 1: Produce Intake & Lot Creation
  Future<ProduceLot> createProduceIntake({
    required String farmerName,
    required String farmerVillage,
    required String cropType,
    required double quantityKg,
    required String photoAsset,
    required QualityFactors quality,
    required FreshnessMetrics freshness,
  }) async {
    final lotNumber = 20480 + _lots.length + 1;
    final lotId = 'FOS-$lotNumber';
    final now = DateTime.now();

    final newLot = ProduceLot(
      id: lotId,
      farmerName: farmerName,
      farmerVillage: farmerVillage,
      cropType: cropType,
      quantityKg: quantityKg,
      photoAsset: photoAsset,
      stage: LotStage.received,
      quality: quality,
      freshness: freshness,
      intakeTimestamp: now,
      stageHistory: [
        StageHistoryItem(
          stage: LotStage.received,
          timestamp: now,
          actor: 'Operator Somanna (Bay 1)',
          notes: 'Weighed and verified $quantityKg kg from $farmerName.',
        ),
      ],
      isPendingSync: _isOffline,
      expectedPricePerKg: 32.0,
    );

    _lots.insert(0, newLot);
    if (_isOffline) {
      _pendingSyncQueue++;
    }
    notifyListeners();

    // Visual transition 1: Graded
    await Future.delayed(const Duration(milliseconds: 300));
    transitionLotStage(
      newLot.id,
      LotStage.graded,
      actor: 'FasalOS AI Vision',
      notes: 'Automated grade ${quality.grade} confirmed (${(quality.confidence * 100).toInt()}% confidence).',
    );

    // Visual transition 2: Stored in Cold Storage
    await Future.delayed(const Duration(milliseconds: 300));
    transitionLotStage(
      newLot.id,
      LotStage.stored,
      actor: 'Cold Hub Pre-cool Chamber',
      notes: 'Transferred to Bay 3 at ${freshness.chamberTemperature}°C.',
    );

    return _lots.firstWhere((l) => l.id == newLot.id);
  }

  void transitionLotStage(
    String lotId,
    LotStage nextStage, {
    String? actor,
    String? notes,
  }) {
    final index = _lots.indexWhere((l) => l.id == lotId);
    if (index == -1) return;

    final lot = _lots[index];
    final updatedHistory = List<StageHistoryItem>.from(lot.stageHistory);
    updatedHistory.add(
      StageHistoryItem(
        stage: nextStage,
        timestamp: DateTime.now(),
        actor: actor ?? 'FasalOS Coordinator',
        notes: notes ?? 'Status advanced to ${nextStage.displayName}.',
      ),
    );

    _lots[index] = lot.copyWith(
      stage: nextStage,
      stageHistory: updatedHistory,
    );
    notifyListeners();
  }

  // Signature Interaction 4: Aggregation
  void toggleLotSelectionForAggregation(String lotId) {
    if (_selectedLotIdsForAggregation.contains(lotId)) {
      _selectedLotIdsForAggregation.remove(lotId);
    } else {
      _selectedLotIdsForAggregation.add(lotId);
    }
    notifyListeners();
  }

  void clearAggregationSelection() {
    _selectedLotIdsForAggregation.clear();
    notifyListeners();
  }

  void combineSelectedLots() {
    if (_selectedLotIdsForAggregation.isEmpty) return;

    final selectedLots = _lots.where((l) => _selectedLotIdsForAggregation.contains(l.id)).toList();
    if (selectedLots.isEmpty) return;

    final totalWeight = selectedLots.fold(0.0, (acc, l) => acc + l.quantityKg);
    final batchId = 'BAT-${totalWeight.toInt()}-${selectedLots.first.cropType.substring(0, 3).toUpperCase()}';

    _activeBatch = ConsolidatedBatch(
      batchId: batchId,
      cropType: selectedLots.first.cropType,
      grade: selectedLots.first.quality.grade,
      totalWeightKg: totalWeight,
      memberLots: selectedLots,
      createdAt: DateTime.now(),
    );

    // Transition all selected lots to Aggregated stage
    for (final lot in selectedLots) {
      transitionLotStage(
        lot.id,
        LotStage.aggregating,
        actor: 'Aggregation Bay #2',
        notes: 'Merged into consolidated batch $batchId ($totalWeight kg).',
      );
    }

    _selectedLotIdsForAggregation.clear();
    notifyListeners();
  }

  // Buyer Matching & Order Workflow
  BuyerOrder matchBuyerAndCreateOrder({
    required MarketOption marketOption,
    required double requestedKg,
  }) {
    final orderNum = 8000 + _buyerOrders.length + 1;
    final orderId = 'ORD-$orderNum';
    final contributingIds = _activeBatch?.memberLots.map((l) => l.id).toList() ??
        ['FOS-20481', 'FOS-20482', 'FOS-20483'];

    final order = BuyerOrder(
      orderId: orderId,
      buyerName: marketOption.buyerEntity,
      buyerLocation: '${marketOption.title} (${marketOption.distanceKm} km)',
      cropType: _activeBatch?.cropType ?? 'Country Tomatoes',
      requiredGrade: _activeBatch?.grade ?? 'Grade A+',
      requestedQuantityKg: requestedKg,
      agreedRatePerKg: marketOption.expectedPrice,
      totalOrderAmount: requestedKg * marketOption.expectedPrice,
      contributingLotIds: contributingIds,
      status: BuyerOrderStatus.orderPlaced,
      orderTimestamp: DateTime.now(),
      vehicleNumber: 'AP-21-TJ-4491 (Solar Reefer)',
      transportTemp: 11.6,
      progressFraction: 0.15,
    );

    _buyerOrders.insert(0, order);

    // Transition contributing lots to Matched
    for (final id in contributingIds) {
      transitionLotStage(
        id,
        LotStage.matched,
        actor: 'Market Match Engine',
        notes: 'Matched with buyer ${marketOption.buyerEntity} at ₹${marketOption.expectedPrice}/kg.',
      );
    }

    notifyListeners();
    return order;
  }

  void dispatchOrder(String orderId) {
    final index = _buyerOrders.indexWhere((o) => o.orderId == orderId);
    if (index == -1) return;

    final order = _buyerOrders[index];
    _buyerOrders[index] = order.copyWith(
      status: BuyerOrderStatus.inColdTransit,
      progressFraction: 0.65,
    );

    if (_activeBatch != null) {
      _activeBatch!.isDispatched = true;
    }

    for (final lotId in order.contributingLotIds) {
      transitionLotStage(
        lotId,
        LotStage.dispatched,
        actor: 'Cold Transport Reefer AP-21-TJ-4491',
        notes: 'Dispatched in refrigerated container at 11.6°C.',
      );
    }
    notifyListeners();
  }

  void deliverOrderAndCalculateSettlement(String orderId) {
    final index = _buyerOrders.indexWhere((o) => o.orderId == orderId);
    if (index == -1) return;

    final order = _buyerOrders[index];
    _buyerOrders[index] = order.copyWith(
      status: BuyerOrderStatus.delivered,
      progressFraction: 1.0,
    );

    if (_activeBatch != null) {
      _activeBatch!.isDelivered = true;
    }

    final now = DateTime.now();

    // Deliver all lots and generate settlements
    for (final lotId in order.contributingLotIds) {
      transitionLotStage(
        lotId,
        LotStage.delivered,
        actor: 'Buyer Gate Inbound',
        notes: 'Delivered at distribution center. Quality verified.',
      );

      final lotIndex = _lots.indexWhere((l) => l.id == lotId);
      if (lotIndex != -1) {
        final lot = _lots[lotIndex];
        final rate = order.agreedRatePerKg;
        final gross = lot.quantityKg * rate;
        final premium = (lot.quantityKg * 1.6); // Quality bonus
        final hubFee = (lot.quantityKg * 1.2); // Hub service fee
        final net = gross + premium - hubFee;

        final settlementId = 'SET-${9020 + _settlements.length + 1}';
        final newRecord = SettlementRecord(
          settlementId: settlementId,
          lotId: lot.id,
          farmerName: lot.farmerName,
          cropType: lot.cropType,
          quantityKg: lot.quantityKg,
          ratePerKg: rate,
          grossProduceValue: gross,
          coldChainQualityPremium: premium,
          hubHandlingFee: hubFee,
          netFarmerPayout: net,
          bankAccountMasked: 'Bank Account •••• ${9000 + lotIndex}',
          transactionRef: 'DBT-AP-2026-${904200 + _settlements.length}',
          settledAt: now,
          isDisbursed: true,
        );

        _settlements.insert(0, newRecord);

        // Transition lot to Paid
        transitionLotStage(
          lot.id,
          LotStage.paid,
          actor: 'Direct Benefit Transfer (DBT)',
          notes: '₹${net.toStringAsFixed(0)} disbursed directly to farmer bank account.',
        );
      }
    }

    _buyerOrders[index] = _buyerOrders[index].copyWith(
      status: BuyerOrderStatus.settled,
    );

    notifyListeners();
  }

  // Network & Sync
  void toggleOfflineMode() {
    _isOffline = !_isOffline;
    notifyListeners();
  }

  Future<void> triggerSync() async {
    if (_isSyncing || _pendingSyncQueue == 0) return;
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 600));

    // Mark pending lots as synced
    for (int i = 0; i < _lots.length; i++) {
      if (_lots[i].isPendingSync) {
        _lots[i].isPendingSync = false;
      }
    }

    _pendingSyncQueue = 0;
    _isSyncing = false;
    notifyListeners();
  }

  void resetToDemo() {
    _initData();
    _selectedLotIdsForAggregation.clear();
    _activeBatch = null;
    _selectedLotForDetail = null;
    _isOffline = false;
    _pendingSyncQueue = 0;
    _isSyncing = false;
    notifyListeners();
  }
}
