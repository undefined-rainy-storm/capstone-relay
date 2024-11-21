import 'package:flutter/material.dart';
import 'package:relay/models/classes/device.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:relay/widgets/connection_state.dart';

@widgetbook.UseCase(name: 'Default', type: ConnectionStateWidget)
Widget defaultUseCase(BuildContext context) {
  return ConnectionStateWidget(
    target: Device(name: 'Glass', address: 'io::main'),
    connectionStatus: ConnectionStatus.connected,
  );
}

@widgetbook.UseCase(name: 'Disconnected', type: ConnectionStateWidget)
Widget disconnectedUseCase(BuildContext context) {
  return ConnectionStateWidget(
    target: Device(name: 'Glass', address: 'io::main'),
    connectionStatus: ConnectionStatus.disconnected,
  );
}
