import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class SystemDeviceTileWidget extends StatefulWidget {
  final BluetoothDevice device;
  final VoidCallback onOpen;
  final VoidCallback onConnect;

  const SystemDeviceTileWidget({
    super.key,
    required this.device,
    required this.onOpen,
    required this.onConnect,
  });

  @override
  State<SystemDeviceTileWidget> createState() => _SystemDeviceTileWidgetState();
}

class _SystemDeviceTileWidgetState extends State<SystemDeviceTileWidget> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;
  late StreamSubscription<BluetoothConnectionState>
      _connectionStateSubscription;

  @override
  void initState() {
    super.initState();

    _connectionStateSubscription =
        widget.device.connectionState.listen((state) {
      _connectionState = state;
      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    _connectionStateSubscription.cancel();
    super.dispose();
  }

  bool get isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.device.platformName),
      subtitle: Text(widget.device.remoteId.str),
      trailing: ElevatedButton(
        child: isConnected ? const Text('OPEN') : const Text('CONNECT'),
        onPressed: isConnected ? widget.onOpen : widget.onConnect,
      ),
    );
  }
}
