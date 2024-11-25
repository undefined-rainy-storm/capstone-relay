import 'package:flutter/material.dart';
import 'package:relay/models/classes/device.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:relay/widgets/select_ble_device/scan_result_tile.dart';

@widgetbook.UseCase(name: 'Default', type: ScanResultTileWidget)
Widget defaultUseCase(BuildContext context) {
  return ScanResultTileWidget(
    result: ScanResult(
        device: BluetoothDevice(remoteId: DeviceIdentifier('io::main')),
        advertisementData: AdvertisementData(
            advName: 'Test Device',
            txPowerLevel: 0,
            appearance: 0,
            connectable: true,
            manufacturerData: {},
            serviceData: {},
            serviceUuids: []),
        rssi: 0,
        timeStamp: DateTime.now()),
    onTap: () {},
  );
}
