import 'dart:developer';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:relay/utilities/io.dart';

void onDataReceived(List<int> data, ServiceInstance service) {
  printout('onDataReceived');
  printout('$data');
  try {
    printout('$data');
    final String stringValue = String.fromCharCodes(data);
    log('Received BLE data: $stringValue');
    printout('Received BLE data: $stringValue');

    // Send data to UI
    // service.invoke('onBleData', {
    //   'data': stringValue,
    //   'timestamp': DateTime.now().toIso8601String(),
    // });
    printout(stringValue);
    log(stringValue);
  } catch (e) {
    log('Error processing BLE data: $e');
  }
}
