import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/screens/entry.dart';
import 'package:relay/screens/select_ble_device.dart';

GetIt getIt = GetIt.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  getIt.registerSingleton<Config>(await Config.fromSharedPrefs());
  // await BLEForegroundService.initialize();

  runApp(MaterialApp(
    title: 'Relay',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: const EntryScreen(),
  ));
}
