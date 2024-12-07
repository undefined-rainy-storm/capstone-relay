import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';

import 'package:relay/models/classes/serializables/config.dart';

class BluetoothHandler {
  static BluetoothDevice? _device;
  static BluetoothConnectionState? connectionState;
  static Stream<BluetoothConnectionState> get connectionStateStream =>
      _device?.connectionState ?? Stream.empty();
  static StreamSubscription<BluetoothConnectionState>?
      connectionStateSubscription;
  static StreamSubscription? _characteristicSubscription;
  static List<BluetoothService> _services = [];

  static Future<void> connectToStoredDevice() async {
    final Config config = GetIt.I.get<Config>();

    final String targetRemoteId = config.connectionConfig.glassRemoteId;
    final String targetServiceUUID = config.connectionConfig.glassServiceUUID;
    final String targetCharacteristicUUID =
        config.connectionConfig.glassCharacteristicUUID;

    _device = BluetoothDevice.fromId(targetRemoteId);
    connectionStateSubscription = _device?.connectionState.listen((state) {
      connectionState = state;

      if (state == BluetoothConnectionState.connected) {
        _services = [];
      }
    });

    Timer.run(() => print('Connecting to $targetServiceUUID'));
    try {
      _device = BluetoothDevice.fromId(targetServiceUUID);

      connectionStateSubscription?.cancel();
      connectionStateSubscription = _device?.connectionState.listen((state) {
        if (state == BluetoothConnectionState.connected) {
          reconnect();
        }
      });
    } catch (e) {
      print('Error: $e');
    }
  }

  static Future<void> reconnect() async {
    await disconnect();
    await connectToStoredDevice();
  }

  static Future<void> disconnect() async {
    await connectionStateSubscription?.cancel();
    await _characteristicSubscription?.cancel();
    await _device?.disconnect();
    _device = null;
  }
}
