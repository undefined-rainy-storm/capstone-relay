import 'package:flutter/material.dart';
import 'package:relay/models/classes/device.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:relay/screens/config.dart';
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
      child: Column(
        children: <Widget>[
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Glass',
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              ConnectionStateWidget(
                  target: Device(
                      name: 'Arduino Nano 33 IoT',
                      address: '19B10000-E8F2-537E-4F6C-D104768A1214'),
                  connectionStatus: ConnectionStatus.connecting)
            ],
          ),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Processor',
                  style: TextStyle(fontSize: 20), textAlign: TextAlign.center),
              ConnectionStateWidget(
                  target: Device(
                      name: 'Server Unit #1', address: 'http://localhost:5000'),
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
      ),
    );
  }
}
