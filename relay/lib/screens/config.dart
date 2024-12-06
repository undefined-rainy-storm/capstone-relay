import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:relay/consts/styles.dart';
import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/screens/select_ble_device.dart';

class ConfigScreen extends StatefulWidget {
  const ConfigScreen({super.key});

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> {
  TextEditingController _connectionConfigGlassServiceUUIDController =
      TextEditingController();
  TextEditingController _connectionConfigGlassCharacteristicUUIDController =
      TextEditingController();
  TextEditingController _connectionConfigProcessorAddressController =
      TextEditingController();

  Future<void> _navigateAndDisplaySelectBleDeviceScreen(
      BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SelectBleDeviceScreen()),
    );

    if (!context.mounted) return;

    setState(() {
      Config config = GetIt.I.get<Config>();
      _connectionConfigGlassServiceUUIDController.text =
          config.connectionConfig.glassServiceUUID;
      _connectionConfigGlassCharacteristicUUIDController.text =
          config.connectionConfig.glassCharacteristicUUID;
      _connectionConfigProcessorAddressController.text =
          config.connectionConfig.processorAddress;
    });
  }

  @override
  void initState() {
    super.initState();
    Config config = GetIt.I.get<Config>();
    _connectionConfigGlassServiceUUIDController.text =
        config.connectionConfig.glassServiceUUID;
    _connectionConfigGlassCharacteristicUUIDController.text =
        config.connectionConfig.glassCharacteristicUUID;
    _connectionConfigProcessorAddressController.text =
        config.connectionConfig.processorAddress;
  }

  void _saveButtonOnPressed() {
    Config config = GetIt.I.get<Config>();
    config.saveToSharedPrefs();

    Navigator.pop(context);
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
            child: Container(
                margin: ScaffoldCommonOptions.rootBodyMargin,
                child: Column(children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(AppLocalizations.of(context)!
                          .configScreen_subtitleConnection),
                      Column(
                        children: [
                          Text(AppLocalizations.of(context)!
                              .configScreen_glassServiceUUIDLabel),
                          TextField(
                            controller:
                                _connectionConfigGlassServiceUUIDController,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .configScreen_glassServiceUUIDHint,
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
                          Text(AppLocalizations.of(context)!
                              .configScreen_glassCharacteristicUUIDLabel),
                          TextField(
                            controller:
                                _connectionConfigGlassCharacteristicUUIDController,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .configScreen_glassCharacteristicUUIDLabel,
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
                          Text(AppLocalizations.of(context)!
                              .configScreen_processorAddressLabel),
                          TextField(
                            controller:
                                _connectionConfigProcessorAddressController,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)!
                                    .configScreen_processorAddressHint),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                          onPressed: _saveButtonOnPressed,
                          child: Text(AppLocalizations.of(context)!
                              .configScreen_saveButtonText)),
                    ],
                  ),
                ]))));
  }
}
