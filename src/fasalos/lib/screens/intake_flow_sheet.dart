import 'package:flutter/material.dart';
import '../models/produce_lot.dart';
import '../services/fasal_state.dart';
import '../theme/app_theme.dart';
import '../l10n/app_localizations.dart';
import '../widgets/quality_assessment.dart';

class IntakeFlowSheet extends StatefulWidget {
  final FasalState state;
  final VoidCallback onCompleted;

  const IntakeFlowSheet({
    super.key,
    required this.state,
    required this.onCompleted,
  });

  @override
  State<IntakeFlowSheet> createState() => _IntakeFlowSheetState();
}

class _IntakeFlowSheetState extends State<IntakeFlowSheet> {
  int _currentStep = 0; // 0: Form, 1: AI Vision, 2: State Transition
  final _formKey = GlobalKey<FormState>();

  String _farmerName = 'Lakshmi Devi';
  String _village = 'Dhone, Kurnool Dist.';
  String _selectedCrop = 'Country Tomatoes';
  double _quantityKg = 250.0;
  String _photoAsset = 'assets/images/produce_tomatoes.jpg';

  // AI Factors
  QualityFactors _qualityFactors = const QualityFactors(
    colorMaturity: 0.89,
    sizingUniformity: 0.92,
    blemishRate: 0.03,
    firmnessIndex: 0.91,
    confidence: 0.94,
    grade: 'A+',
  );

  bool _isAnalyzing = false;
  ProduceLot? _createdLot;
  LotStage _animatingStage = LotStage.received;

  final List<Map<String, String>> _cropOptions = [
    {'name': 'Country Tomatoes', 'photo': 'assets/images/produce_tomatoes.jpg'},
    {'name': 'Red Onions', 'photo': 'assets/images/produce_onions.jpg'},
    {'name': 'G4 Green Chillies', 'photo': 'assets/images/produce_chillies.jpg'},
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: FasalColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: FasalColors.borderStrong,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Top Header Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.add_shopping_cart, color: FasalColors.primaryGreen, size: 22),
                    const SizedBox(width: 8),
                    Text(
                      l10n.get('intake_title'),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: FasalColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
          ),
          const Divider(),

          // Body Content by Step
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              child: _buildCurrentStep(context, l10n),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentStep(BuildContext context, AppLocalizations l10n) {
    switch (_currentStep) {
      case 0:
        return _buildStep1Form(context, l10n);
      case 1:
        return _buildStep2AiInspection(context, l10n);
      case 2:
      default:
        return _buildStep3Transition(context, l10n);
    }
  }

  Widget _buildStep1Form(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      key: const ValueKey('step1'),
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.get('intake_step_1'),
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: FasalColors.primaryGreen),
            ),
            const SizedBox(height: 12),

            // Crop Variety Selector
            Text(
              l10n.get('select_crop'),
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: FasalColors.textSecondary),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: _cropOptions.map((opt) {
                  final isSel = _selectedCrop == opt['name'];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(opt['name']!),
                      selected: isSel,
                      onSelected: (val) {
                        setState(() {
                          _selectedCrop = opt['name']!;
                          _photoAsset = opt['photo']!;
                        });
                      },
                      selectedColor: FasalColors.primaryGreen,
                      backgroundColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSel ? Colors.white : FasalColors.textPrimary,
                        fontWeight: isSel ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 14),

            // Farmer Name Field
            TextFormField(
              initialValue: _farmerName,
              decoration: InputDecoration(
                labelText: l10n.get('farmer_name'),
                prefixIcon: const Icon(Icons.person),
              ),
              onChanged: (val) => _farmerName = val,
            ),
            const SizedBox(height: 12),

            // Village Field
            TextFormField(
              initialValue: _village,
              decoration: InputDecoration(
                labelText: l10n.get('village_location'),
                prefixIcon: const Icon(Icons.location_on),
              ),
              onChanged: (val) => _village = val,
            ),
            const SizedBox(height: 14),

            // Quantity Slider & Field (250 kg)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.get('quantity_kg'),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: FasalColors.primaryGreen,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${_quantityKg.toInt()} kg',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                  ),
                ),
              ],
            ),
            Slider(
              value: _quantityKg,
              min: 50,
              max: 1000,
              divisions: 19,
              activeColor: FasalColors.primaryGreen,
              onChanged: (val) {
                setState(() {
                  _quantityKg = val;
                });
              },
            ),
            const SizedBox(height: 14),

            // Harvest Photography Preview Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: FasalColors.borderSubtle),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      _photoAsset,
                      width: 68,
                      height: 68,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(Icons.camera_alt, size: 36),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Crate Photo Captured',
                          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'High-resolution camera connected at Intake Weighbridge Bay 1.',
                          style: TextStyle(fontSize: 11, color: FasalColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Proceed Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  setState(() {
                    _currentStep = 1;
                  });
                },
                icon: const Icon(Icons.arrow_forward),
                label: Text(l10n.get('run_ai_assessment')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep2AiInspection(BuildContext context, AppLocalizations l10n) {
    return SingleChildScrollView(
      key: const ValueKey('step2'),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.get('intake_step_2'),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: FasalColors.primaryGreen),
          ),
          const SizedBox(height: 12),

          // Crop Photo with AI scanning indicator
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              children: [
                Image.asset(
                  _photoAsset,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '$_selectedCrop • ${_quantityKg.toInt()} kg',
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Quality Assessment Factor Breakdown
          QualityAssessmentWidget(
            quality: _qualityFactors,
            cropType: _selectedCrop,
            onGradeChanged: (newGrade) {
              setState(() {
                _qualityFactors = _qualityFactors.copyWith(grade: newGrade);
              });
            },
          ),
          const SizedBox(height: 20),

          // Confirm & Create Lot Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: _isAnalyzing
                  ? null
                  : () async {
                      setState(() {
                        _isAnalyzing = true;
                      });

                      final newLot = await widget.state.createProduceIntake(
                        farmerName: _farmerName,
                        farmerVillage: _village,
                        cropType: _selectedCrop,
                        quantityKg: _quantityKg,
                        photoAsset: _photoAsset,
                        quality: _qualityFactors,
                        freshness: const FreshnessMetrics(
                          freshnessScore: 94,
                          chamberTemperature: 11.8,
                          relativeHumidity: 88.0,
                          storageDurationHours: 1,
                          estimatedRemainingDays: 14,
                          cropCondition: 'Prime Crisp Harvest',
                          scientificExplanation:
                              'Rapid pre-cooling immediately after intake stabilizes ethylene production and respiration rates.',
                        ),
                      );

                      setState(() {
                        _createdLot = newLot;
                        _currentStep = 2;
                        _isAnalyzing = false;
                        _animatingStage = LotStage.received;
                      });

                      // Trigger visible stage transitions: Received -> Graded -> Stored
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (mounted) {
                        setState(() => _animatingStage = LotStage.graded);
                      }
                      await Future.delayed(const Duration(milliseconds: 300));
                      if (mounted) {
                        setState(() => _animatingStage = LotStage.stored);
                      }
                    },
              icon: _isAnalyzing
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Icon(Icons.verified),
              label: Text(l10n.get('operator_confirm')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep3Transition(BuildContext context, AppLocalizations l10n) {
    final lot = _createdLot;
    if (lot == null) return const SizedBox.shrink();

    final isReceived = _animatingStage.stepIndex >= LotStage.received.stepIndex;
    final isGraded = _animatingStage.stepIndex >= LotStage.graded.stepIndex;
    final isStored = _animatingStage.stepIndex >= LotStage.stored.stepIndex;

    return SingleChildScrollView(
      key: const ValueKey('step3'),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: FasalColors.successSubtle,
            ),
            child: const Icon(Icons.check_circle, size: 48, color: FasalColors.success),
          ),
          const SizedBox(height: 12),
          Text(
            'Lot Created: ${lot.id}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: FasalColors.primaryGreenDark,
            ),
          ),
          Text(
            '${lot.farmerName} • ${lot.cropType} (${lot.quantityKg.toInt()} kg)',
            style: const TextStyle(fontSize: 13, color: FasalColors.textSecondary),
          ),
          const SizedBox(height: 24),

          // Visual Transition: Received -> Graded -> Stored
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: FasalColors.borderSubtle),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Automated State Transition Stream',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: FasalColors.textMuted),
                ),
                const SizedBox(height: 14),

                _buildTransitionStepRow(
                  label: '1. Received at Intake Bay',
                  sub: 'Gross tare 250 kg verified by Operator',
                  isDone: isReceived,
                  icon: Icons.scale,
                ),
                _buildConnectorLine(isGraded),
                _buildTransitionStepRow(
                  label: '2. Graded by Computer Vision',
                  sub: 'Classified Grade ${lot.quality.grade} (${(lot.quality.confidence * 100).toInt()}% confidence)',
                  isDone: isGraded,
                  icon: Icons.psychology,
                ),
                _buildConnectorLine(isStored),
                _buildTransitionStepRow(
                  label: '3. Stored in Solar Cold Room',
                  sub: 'Pre-cool chamber at 11.8°C (88% RH)',
                  isDone: isStored,
                  icon: Icons.ac_unit,
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onCompleted();
              },
              icon: const Icon(Icons.done),
              label: const Text('View Lot in Cold Storage Hub'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransitionStepRow({
    required String label,
    required String sub,
    required bool isDone,
    required IconData icon,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isDone ? FasalColors.success : FasalColors.surfaceMuted,
            border: Border.all(color: isDone ? FasalColors.success : FasalColors.borderStrong),
          ),
          child: Center(
            child: isDone
                ? const Icon(Icons.check, size: 18, color: Colors.white)
                : Icon(icon, size: 16, color: FasalColors.textMuted),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isDone ? FasalColors.textPrimary : FasalColors.textMuted,
                ),
              ),
              Text(
                sub,
                style: TextStyle(
                  fontSize: 11,
                  color: isDone ? FasalColors.textSecondary : FasalColors.textMuted,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine(bool isDone) {
    return Container(
      margin: const EdgeInsets.only(left: 15, top: 4, bottom: 4),
      width: 2,
      height: 18,
      color: isDone ? FasalColors.success : FasalColors.borderSubtle,
    );
  }
}
