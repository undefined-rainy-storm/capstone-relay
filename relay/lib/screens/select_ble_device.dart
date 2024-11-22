import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:relay/l10n/app_localizations.dart';

class SelectBleDeviceScreen extends StatefulWidget {
  const SelectBleDeviceScreen({super.key});

  @override
  State<SelectBleDeviceScreen> createState() => _SelectBleDeviceScreenState();
}

class _SelectBleDeviceScreenState extends State<SelectBleDeviceScreen> {
  List<BluetoothDevice> devices = [];
  StreamSubscription? scanSubscription;

  Future<void> _scanDevices() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

    scanSubscription =
        FlutterBluePlus.scanResults.listen((List<ScanResult> results) {
      for (ScanResult each in results) {
        if (!devices.contains(each.device)) {
          setState(() {
            devices.add(each.device);
          });
        }
      }
    });

    if (scanSubscription != null) {
      FlutterBluePlus.cancelWhenScanComplete(scanSubscription!);
    }
  }

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _scanDevices();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.of(context).pop(),
        )),
        body: SafeArea(
          child: Center(
              child: StreamBuilder<bool>(
                  stream: FlutterBluePlus.isScanning,
                  initialData: false,
                  builder: (context, snapshot) {
                    final bool isScanning = snapshot.data ?? false;
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
                                final BluetoothDevice device = devices[index];
                                return ListTile(
                                  title: Text(
                                    device.advName.isNotEmpty
                                        ? device.advName
                                        : AppLocalizations.of(context)!
                                            .selectBleDeviceScreen_unknownDeviceName,
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  subtitle: Text(
                                    device.remoteId.toString(),
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onTap: () {
                                    Navigator.of(context).pop(device);
                                  },
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: isScanning ? null : _scanDevices,
                            child: Text(isScanning
                                ? AppLocalizations.of(context)!
                                    .selectBleDeviceScreen_scanButtonNowScanningText
                                : AppLocalizations.of(context)!
                                    .selectBleDeviceScreen_scanButtonText),
                          ),
                        ]);
                  })),
        ));
  }
}
