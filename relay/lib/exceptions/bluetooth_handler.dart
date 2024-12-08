class BluetoothHandlerException implements Exception {
  BluetoothHandlerException({required this.message});
  String message;
}

class BluetoothNotSupportedException extends BluetoothHandlerException {
  BluetoothNotSupportedException(
      {super.message = 'Bluetooth is not supported'});
}

class BluetoothAdapterStateIsNotOnException extends BluetoothHandlerException {
  BluetoothAdapterStateIsNotOnException(
      {super.message = 'Bluetooth adapter state is not on'});
}

class StoredDeviceIsNotExistsException extends BluetoothHandlerException {
  StoredDeviceIsNotExistsException(
      {super.message = 'Stored device is not exists'});
}

class StoredDeviceServiceIsNotExistsException
    extends BluetoothHandlerException {
  StoredDeviceServiceIsNotExistsException(
      {super.message = 'Service UUID is not set'});
}

class StoredDeviceCharacteristicIsNotExistsException
    extends BluetoothHandlerException {
  StoredDeviceCharacteristicIsNotExistsException(
      {super.message = 'Characteristic UUID is not set'});
}

class DeviceNotConnectedException extends BluetoothHandlerException {
  DeviceNotConnectedException({super.message = 'Device is not connected'});
}
