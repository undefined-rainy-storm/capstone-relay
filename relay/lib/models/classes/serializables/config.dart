import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:relay/models/classes/extensions/bluetooth_device.dart';
import 'package:relay/models/classes/serializables/connection_config.dart';

const String jsonSerializedKeyConfig = 'config';

class JsonSerializedKeysConfig {
  static const connectionConfig = 'connection_config';
}

class Config {
  ConnectionConfig connectionConfig;

  Config({required this.connectionConfig});

  static Future<Config> fromSharedPrefs() async {
    return Config(
      connectionConfig: await ConnectionConfig.fromSharedPrefs(),
    );
  }

  void saveToSharedPrefs() async {
    await connectionConfig.saveToSharedPrefs();
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
        connectionConfig: ConnectionConfig.fromJson(
            json[JsonSerializedKeysConfig.connectionConfig]));
  }

  Map<String, dynamic> toJson() => {
        JsonSerializedKeysConfig.connectionConfig: connectionConfig.toJson(),
      };

  static Future<void> setBleDevice(BluetoothDevice device) async {
    final Config config = GetIt.I.get<Config>();
    Timer.run(() => print('Connecting to ${device.advName}'));
    device.connectAndUpdateStream().catchError((e) {
      print('Error: $e');
    });
    Timer.run(() => print('Connected to ${device.advName}'));

    config.connectionConfig.glassCachedName = device.advName;
    config.connectionConfig.glassRemoteId = device.remoteId.toString();
    Timer.run(() => print('${config.connectionConfig.toJson()}'));

    await device.connect();
    List<BluetoothService> services = await device.discoverServices();
    if (services.length > 0) {
      BluetoothService service = services.first;
      config.connectionConfig.glassServiceUUID = service.uuid.toString();
      List<BluetoothCharacteristic> characteristics =
          await service.characteristics;
      if (characteristics.length > 0) {
        BluetoothCharacteristic characteristic = characteristics.first;
        config.connectionConfig.glassCharacteristicUUID =
            characteristic.uuid.toString();
      }
    }
  }
}
