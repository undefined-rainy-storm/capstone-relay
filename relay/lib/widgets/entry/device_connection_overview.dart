import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:relay/models/classes/device.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:relay/providers/config_provider.dart';
import 'package:relay/screens/config.dart';
import 'package:relay/services/bluetooth_handler.dart';
import 'package:relay/widgets/connection_state.dart';

class DeviceConnectionOverviewWidget extends StatefulWidget {
  const DeviceConnectionOverviewWidget({super.key});

  @override
  State<DeviceConnectionOverviewWidget> createState() =>
      _DeviceConnectionOverviewWidgetState();
}

class _DeviceConnectionOverviewWidgetState
    extends State<DeviceConnectionOverviewWidget> {
  Future<void> _navigateAndDisplayConfigScreen(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ConfigScreen()),
    );

    if (!context.mounted) return;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Consumer<ConfigProvider>(builder: (context, provider, child) {
        return Column(
          children: <Widget>[
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Glass',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                StreamBuilder<BluetoothConnectionState>(
                  stream: BluetoothHandler().connectionStateStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ConnectionStateWidget(
                          target: Device(
                              name: provider
                                  .config.connectionConfig.glassCachedName,
                              address: provider
                                  .config.connectionConfig.glassServiceUUID),
                          connectionStatus: snapshot.data ==
                                  BluetoothConnectionState.connected
                              ? ConnectionStatus.connected
                              : ConnectionStatus.disconnected);
                    } else {
                      return ConnectionStateWidget(
                          target: Device(
                              name: provider
                                  .config.connectionConfig.glassCachedName,
                              address: provider
                                  .config.connectionConfig.glassServiceUUID),
                          connectionStatus: ConnectionStatus.connecting);
                    }
                  },
                ),
              ],
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Processor',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center),
                ConnectionStateWidget(
                    target: Device(
                        name: provider.config.connectionConfig.processorName,
                        address:
                            provider.config.connectionConfig.processorAddress),
                    connectionStatus: ConnectionStatus.connecting)
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _navigateAndDisplayConfigScreen(context);
              },
              child: const Text('Config...'),
            )
          ],
        );
      }),
    );
  }
}
