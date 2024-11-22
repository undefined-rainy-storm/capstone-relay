import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/screens/load_qr_config.dart';
import 'package:relay/screens/select_ble_device.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController _connectionConfigGlassRemoteIdController =
      TextEditingController();
  TextEditingController _connectionConfigProcessorAddress =
      TextEditingController();

  Future<void> _navigateAndDisplaySelectBleDeviceScreen(
      BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectBleDeviceScreen()),
    );

    if (!context.mounted) return;
  }

  @override
  void initState() {
    super.initState();
    Config config = GetIt.I.get<Config>();
    _connectionConfigGlassRemoteIdController.text =
        config.connectionConfig.glassRemoteId;
    _connectionConfigProcessorAddress.text =
        config.connectionConfig.processorAddress;
  }

  void _saveButtonOnPressed() {}

  Future<void> _navigateAndDisplayLoadQrConfigScreen(
      BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoadQrConfigScreen()),
    );

    if (!context.mounted) return;
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
          child: Column(
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Text('Connection'),
                  Column(
                    children: [
                      const Text('Glass Remote ID'),
                      TextField(
                        controller: _connectionConfigGlassRemoteIdController,
                        decoration: InputDecoration(
                            hintText: 'Glass Remote ID',
                            suffixIcon: IconButton(
                                onPressed: () {
                                  _navigateAndDisplaySelectBleDeviceScreen(
                                      context);
                                },
                                icon: Icon(Icons.settings_bluetooth))),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text('Processor Address'),
                      TextField(
                        controller: _connectionConfigProcessorAddress,
                        decoration:
                            InputDecoration(hintText: 'Processor Address'),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 10),
              Row(children: [
                ElevatedButton(
                    onPressed: _saveButtonOnPressed, child: Text('Save')),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      _navigateAndDisplayLoadQrConfigScreen(context);
                    },
                    child: Text('Load using QR code')),
              ])
            ],
          ),
        ));
  }
}
