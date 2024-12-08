import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
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

  Future<void> saveToSharedPrefs() async {
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

  Future<void> setDevice(BluetoothDevice device) async {
    Timer.run(() => print('Connecting to ${device.platformName}'));
    await device.connect();
    Timer.run(() => print('Connected to ${device.platformName}'));

    connectionConfig.glassCachedName = device.platformName;
    connectionConfig.glassRemoteId = device.remoteId.toString();
    await saveToSharedPrefs();
    Timer.run(() => print('${connectionConfig.toJson()}'));

    List<BluetoothService> services = await device.discoverServices();
    if (services.isNotEmpty) {
      BluetoothService service = services.first;
      connectionConfig.glassServiceUUID = service.uuid.toString();
      List<BluetoothCharacteristic> characteristics = service.characteristics;
      if (characteristics.isNotEmpty) {
        BluetoothCharacteristic characteristic = characteristics.first;
        connectionConfig.glassCharacteristicUUID =
            characteristic.uuid.toString();
      }
    }
    await saveToSharedPrefs();
  }

  Future<void> resetDevice() async {
    connectionConfig.glassCachedName = '';
    connectionConfig.glassRemoteId = '';
    connectionConfig.glassServiceUUID = '';
    connectionConfig.glassCharacteristicUUID = '';
    await saveToSharedPrefs();
  }
}
