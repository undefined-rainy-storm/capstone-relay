import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

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
                      Text(
                          'Bluetooth ${devices.length} device${devices.length == 1 ? '' : 's'} found.'),
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
                                    : 'Unknown',
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
                        child: Text(isScanning ? 'Scanning...' : 'Scan'),
                      ),
                    ]);
              })),
    ));
  }
}
