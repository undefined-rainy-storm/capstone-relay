import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';

void onDataReceived(List<int> data, ServiceInstance service) {
  try {
    final String stringValue = String.fromCharCodes(data);
    log('Received BLE data: $stringValue');

    // Send data to UI
    service.invoke('onBleData', {
      'data': stringValue,
      'timestamp': DateTime.now().toIso8601String(),
    });
    log(stringValue);
  } catch (e) {
    log('Error processing BLE data: $e');
  }
}
