import 'package:flutter/material.dart';
import 'services/fasal_state.dart';
import 'theme/app_theme.dart';
import 'l10n/app_localizations.dart';
import 'screens/main_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FasalOSApp());
}

class FasalOSApp extends StatefulWidget {
  const FasalOSApp({super.key});

  @override
  State<FasalOSApp> createState() => _FasalOSAppState();
}

class _FasalOSAppState extends State<FasalOSApp> {
  late final FasalState _fasalState;

  @override
  void initState() {
    super.initState();
    _fasalState = FasalState();
  }

  @override
  void dispose() {
    _fasalState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocalizationProvider(
      child: ListenableBuilder(
        listenable: _fasalState,
        builder: (context, child) {
          final l10n = AppLocalizations.of(context);

          return MaterialApp(
            title: l10n.get('app_title'),
            debugShowCheckedModeBanner: false,
            theme: FasalTheme.lightTheme,
            home: MainShell(state: _fasalState),
          );
        },
      ),
    );
  }
}
