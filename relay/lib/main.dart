import 'package:flutter/material.dart';

import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/screens/entry.dart';
import 'package:relay/screens/select_ble_device.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await BLEForegroundService.initialize();

  runApp(MaterialApp(
    title: 'Relay',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const SelectBleDeviceScreen(),
  ));
}
