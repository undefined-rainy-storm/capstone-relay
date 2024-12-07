import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/services/bluetooth_handler.dart';

void startBackgroundService() {
  final service = FlutterBackgroundService();
  service.startService();
}

void stopBackgroundService() {
  final service = FlutterBackgroundService();
  service.invoke('stop');
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: false,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}

@pragma('vm:entry-point')
Future<void> onStart(ServiceInstance service) async {
  if (!(GetIt.I.isRegistered<Config>())) {
    GetIt.I.registerSingleton<Config>(await Config.fromSharedPrefs());
  }

  if (await FlutterBluePlus.isSupported == false) {
    print('Bluetooth is not supported');
    return;
  }

  try {
    if (Platform.isIOS) {
      // Wait for Bluetooth adapter state on iOS
      await FlutterBluePlus.adapterState
          .where((state) => state == BluetoothAdapterState.on)
          .first
          .timeout(
            const Duration(seconds: 10),
            onTimeout: () => throw TimeoutException('Bluetooth not ready'),
          );

      // iOS requires only system permissions dialog, no explicit request needed
      await Future.delayed(const Duration(seconds: 1));
    }

    if (Platform.isAndroid) {
      await FlutterBluePlus.turnOn();
    }

    print('BLE initialized, connecting to stored device...');
    await BluetoothHandler.connectToStoredDevice();
  } catch (e) {
    Timer.run(() => print('BLE initialization error: $e'));
  }

  print('Started');

  BluetoothHandler.connectToStoredDevice();

  Timer.periodic(const Duration(seconds: 1), (timer) {
    Config config = GetIt.I.get<Config>();
    print('${DateTime.now()}: ${config.toJson()}');
    print("service is successfully running ${DateTime.now().second}");
  });
}
