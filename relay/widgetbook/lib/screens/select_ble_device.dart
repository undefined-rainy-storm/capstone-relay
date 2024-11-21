import 'package:flutter/material.dart';
import 'package:relay/models/classes/device.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:relay/screens/select_ble_device.dart';

@widgetbook.UseCase(name: 'Default', type: SelectBleDeviceScreen)
Widget defaultUseCase(BuildContext context) {
  return const SelectBleDeviceScreen();
}
