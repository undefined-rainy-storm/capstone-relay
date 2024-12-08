import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:relay/exceptions/bluetooth_handler.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/services/bluetooth_handler.dart';
import 'package:relay/services/background_bluetooth_handler.dart'
    as background_handler;
import 'package:relay/utilities/io.dart';

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
  if (await FlutterBluePlus.isSupported == false) {
    throw BluetoothNotSupportedException();
  }

  if (Platform.isIOS) {
    await FlutterBluePlus.adapterState
        .where((state) => state == BluetoothAdapterState.on)
        .first
        .timeout(
          const Duration(seconds: 10),
          onTimeout: () => throw BluetoothAdapterStateIsNotOnException(),
        );
  }
  if (Platform.isAndroid) {
    await FlutterBluePlus.turnOn();
  }
  log('Bluetooth is supported and adapter state is on');

  printout('Starting background service');

  // BluetoothHandler -> call establishAutoConnection
  while (true) {
    try {
      await BluetoothHandler().establishAutoConnection();
      break;
    } on BluetoothHandlerException catch (e) {
      log('Error establishing auto connection: $e. Retrying in 5 seconds');
      printout('Error establishing auto connection: $e. Retrying in 5 seconds');
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  // BluetoothHandler().characteristic!.setNotifyValue(true);
  StreamSubscription streamSubscription = BluetoothHandler()
      .characteristic!
      .lastValueStream
      .listen((data) => background_handler.onDataReceived(data, service));

/*
  Timer.periodic(Duration(seconds: 1), (timer) async {
    Config config = await Config.fromSharedPrefs();
    printout('${DateTime.now()}');
    printout('$streamSubscription');
    printout('${streamSubscription.isPaused}');
    printout('${BluetoothHandler().characteristic!.lastValue}');
    printout('${config.toJson()}');
  });*/
}
