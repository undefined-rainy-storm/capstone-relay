import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/services/blue_handler.dart';

class SelectBleDeviceScreen extends StatefulWidget {
  const SelectBleDeviceScreen({super.key});

  @override
  State<SelectBleDeviceScreen> createState() => _SelectBleDeviceScreenState();
}

class _SelectBleDeviceScreenState extends State<SelectBleDeviceScreen> {
  final BlueHandler _blueHandler = BlueHandler();

  @override
  void initState() {
    super.initState();
    _blueHandler.clearDevices();
    _blueHandler.scanDevices();
  }

  void _onDeviceSelected(BluetoothDevice device) {
    _blueHandler.connectDevice(device);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: StreamBuilder<bool>(
            stream: FlutterBluePlus.isScanning,
            initialData: false,
            builder: (context, scanningSnapshot) {
              final bool isScanning = scanningSnapshot.data ?? false;

              return StreamBuilder<List<BluetoothDevice>>(
                stream: _blueHandler.devicesStream,
                initialData: const [],
                builder: (context, devicesSnapshot) {
                  final devices = devicesSnapshot.data ?? [];

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!
                          .selectBleDeviceScreen_bluetoothDevicesFound(
                              devices.length)),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: devices.length,
                          itemBuilder: (context, index) {
                            final device = devices[index];
                            return ListTile(
                              title: Text(
                                device.advName.isNotEmpty
                                    ? device.advName
                                    : AppLocalizations.of(context)!
                                        .selectBleDeviceScreen_unknownDeviceName,
                                style: const TextStyle(fontSize: 14),
                              ),
                              subtitle: Text(
                                device.remoteId.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                              onTap: () => _onDeviceSelected(device),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: isScanning ? null : _blueHandler.scanDevices,
                        child: Text(isScanning
                            ? AppLocalizations.of(context)!
                                .selectBleDeviceScreen_scanButtonNowScanningText
                            : AppLocalizations.of(context)!
                                .selectBleDeviceScreen_scanButtonText),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
