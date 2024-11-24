import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BlueHandler {
  static final BlueHandler _instance = BlueHandler._internal();

  factory BlueHandler() {
    return _instance;
  }

  BlueHandler._internal();

  final List<BluetoothDevice> devices = [];
  StreamSubscription? scanSubscription;
  final _devicesController =
      StreamController<List<BluetoothDevice>>.broadcast();
  Stream<List<BluetoothDevice>> get devicesStream => _devicesController.stream;

  Future<void> scanDevices() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    scanSubscription =
        FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult each in results) {
        if (!devices.contains(each.device)) {
          devices.add(each.device);
          _devicesController.add(List.from(devices));
        }
      }
    });

    if (scanSubscription != null) {
      FlutterBluePlus.cancelWhenScanComplete(scanSubscription!);
    }
  }

  void connectDevice(BluetoothDevice device) async {
    await device.connect();
    print('connect to ${device.advName}');

    List<BluetoothService> services = await device.discoverServices();

    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        print('characteristic: ${characteristic.uuid}');
        await characteristic.setNotifyValue(true);
        characteristic.value.listen((value) {
          print('value: $value');
        });
      }
    }
  }

  void dispose() {
    scanSubscription?.cancel();
    _devicesController.close();
  }

  void clearDevices() {
    devices.clear();
    _devicesController.add([]);
  }
}
