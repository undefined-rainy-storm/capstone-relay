import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:relay/exceptions/bluetooth_handler.dart';
import 'package:relay/models/classes/serializables/config.dart';

class BluetoothHandler {
  BluetoothHandler._();
  static final BluetoothHandler _instance = BluetoothHandler._();
  factory BluetoothHandler() {
    return _instance;
  }

  BluetoothDevice? _device;
  BluetoothDevice? get device => _device;

  BluetoothConnectionState? _connectionState;
  BluetoothConnectionState? get connectionState => _connectionState;
  Stream<BluetoothConnectionState> get connectionStateStream =>
      _device?.connectionState ?? const Stream.empty();

  BluetoothService? _service;
  BluetoothService? get service => _service;

  BluetoothCharacteristic? _characteristic;
  BluetoothCharacteristic? get characteristic => _characteristic;
  Stream<List<int>>? get characteristicStream =>
      _characteristic?.lastValueStream;

  Future<void> establishAutoConnection() async {
    // StoredDeviceIsNotExistsException is thrown if there is no stored device
    await connectToStoredDevice();

    if (_device == null) {
      throw DeviceNotConnectedException();
    }

    Config config = await Config.fromSharedPrefs();
    if (config.connectionConfig.glassServiceUUID.isEmpty) {
      throw StoredDeviceServiceIsNotExistsException();
    }
    if (config.connectionConfig.glassCharacteristicUUID.isEmpty) {
      throw StoredDeviceCharacteristicIsNotExistsException();
    }

    // End Validation
    // Start handling the service and characteristic

    for (BluetoothService eachService in await _device!.discoverServices()) {
      if (eachService.uuid.toString() ==
          config.connectionConfig.glassServiceUUID) {
        _service = eachService;
        for (BluetoothCharacteristic eachCharacteristic
            in eachService.characteristics) {
          if (eachCharacteristic.uuid.toString() ==
              config.connectionConfig.glassCharacteristicUUID) {
            _characteristic = eachCharacteristic;
            return;
          }
        }
      }
    }
  }

  Future<void> connectToStoredDevice() async {
    Config config = await Config.fromSharedPrefs();
    if (config.connectionConfig.glassRemoteId.isEmpty) {
      throw StoredDeviceIsNotExistsException();
    }
    BluetoothDevice device =
        BluetoothDevice.fromId(config.connectionConfig.glassRemoteId);
    await connect(device);
  }

  Future<void> connect(BluetoothDevice device) async {
    try {
      _device = device;
      await _device!.connect(timeout: const Duration(seconds: 10));
      await _setupConnectionStateSubscription();
    } catch (e) {
      log('Error connecting to stored device: $e');
      rethrow;
    }
  }

  Future<void> resetConnection() async {
    if (_device == null) {
      throw DeviceNotConnectedException();
    }
    await _device!.disconnect();
    _device = null;
    _service = null;
    _characteristic = null;
  }

  Future<void> cancelConnection() async {
    if (_device == null) {
      throw DeviceNotConnectedException();
    }
    await _device!.disconnect();
  }

  Future<void> _setupConnectionStateSubscription() async {
    _device!.connectionState.listen((state) {
      _connectionState = state;
    });
  }
}
