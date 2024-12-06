import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:relay/consts/styles.dart';
import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/widgets/select_ble_device/scan_result_tile.dart';
import 'package:relay/widgets/select_ble_device/system_device_tile.dart';

class SelectBleDeviceScreen extends StatefulWidget {
  const SelectBleDeviceScreen({super.key});

  @override
  State<SelectBleDeviceScreen> createState() => _SelectBleDeviceScreenState();
}

class _SelectBleDeviceScreenState extends State<SelectBleDeviceScreen> {
  List<BluetoothDevice> _systemDevices = [];
  List<ScanResult> _scanResults = [];

  bool _isScanning = false;
  Config config = GetIt.I.get<Config>();
  final TextEditingController _searchController = TextEditingController();

  late StreamSubscription<List<ScanResult>> _scanResultsSubscription;
  late StreamSubscription<bool> _isScanningSubscription;

  @override
  void initState() {
    super.initState();

    _scanResultsSubscription = FlutterBluePlus.scanResults.listen((results) {
      _scanResults = results;
      if (mounted) {
        setState(() {});
      }
    }, onError: (e) {
      print('Error: $e');
    });

    _isScanningSubscription = FlutterBluePlus.isScanning.listen((state) {
      _isScanning = state;
      if (mounted) {
        setState(() {});
      }
    });

    startScan();
  }

  @override
  void dispose() {
    _scanResultsSubscription.cancel();
    _isScanningSubscription.cancel();
    super.dispose();
  }

  Future<void> _onRefresh() {
    if (_isScanning == false) {
      FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    }
    if (mounted) {
      setState(() {});
    }
    return Future.delayed(Duration(milliseconds: 500));
  }

  Future<void> startScan() async {
    try {
      // `withServices` is required on iOS for privacy purposes, ignored on android.
      var withServices = [Guid("180f")]; // Battery Level Service
      _systemDevices = await FlutterBluePlus.systemDevices(withServices);
    } catch (e) {
      print('error: $e');
    }
    try {
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 15));
    } catch (e) {
      print('error $e');
    }
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> stopScan() async {
    try {
      FlutterBluePlus.stopScan();
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _onScanStartPressed() async => await startScan();

  Future<void> _onScanStopPressed() async => await stopScan();

  Widget _buildScanButton(BuildContext context) {
    if (FlutterBluePlus.isScanningNow) {
      return FloatingActionButton(
        child: const Icon(Icons.stop),
        onPressed: _onScanStopPressed,
        backgroundColor: Colors.red,
      );
    } else {
      return FloatingActionButton(
          child: const Text("SCAN"), onPressed: _onScanStartPressed);
    }
  }

  Widget _buildSearchBar(BuildContext context) {
    return TextField(
      controller: _searchController,
      decoration: InputDecoration(
        hintText: 'Search',
        prefixIcon: const Icon(Icons.search),
      ),
    );
  }

  List<Widget> _buildSystemDeviceTiles(BuildContext context) {
    return _systemDevices
        .where((device) => device.platformName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .map((device) => SystemDeviceTileWidget(
              device: device,
              onOpen: () => {},
              onConnect: () => {},
            ))
        .toList();
  }

  List<Widget> _buildScanResultTiles(BuildContext context) {
    return _scanResults
        .where((result) => result.device.platformName
            .toLowerCase()
            .contains(_searchController.text.toLowerCase()))
        .map((result) => ScanResultTileWidget(
              result: result,
              onTap: () => {
                /*
                config
                    .connectionConfig
                    .
                    // Setter로 통과시킥;
                    config
                    .connectionConfig
                    .glassRemoteId = result.device.remoteId.str,*/
              },
            ))
        .toList();
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
        child: Container(
            margin: ScaffoldCommonOptions.rootBodyMargin,
            child: RefreshIndicator(
                child: ListView(children: <Widget>[
                  _buildSearchBar(context),
                  ..._buildSystemDeviceTiles(context),
                  ..._buildScanResultTiles(context),
                ]),
                onRefresh: _onRefresh)),
      ),
      floatingActionButton: _buildScanButton(context),
    );
  }
}
