import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class ScanResultTileWidget extends StatefulWidget {
  const ScanResultTileWidget({super.key, required this.result, this.onTap});

  final ScanResult result;
  final VoidCallback? onTap;

  @override
  State<ScanResultTileWidget> createState() => _ScanResultTileWidgetState();
}

class _ScanResultTileWidgetState extends State<ScanResultTileWidget> {
  BluetoothConnectionState _connectionState =
      BluetoothConnectionState.disconnected;

  bool get _isConnected {
    return _connectionState == BluetoothConnectionState.connected;
  }

  Widget _buildTitle(BuildContext context) {
    if (widget.result.device.platformName.isNotEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.result.device.platformName,
            overflow: TextOverflow.ellipsis,
          ),
          Text(widget.result.device.remoteId.str,
              style: Theme.of(context).textTheme.bodySmall)
        ],
      );
    } else {
      return Text(widget.result.device.remoteId.str);
    }
  }

  Widget _buildConnectButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      onPressed: widget.onTap,
      child: _isConnected ? const Text('Open') : const Text('Connect'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: _buildTitle(context),
      trailing: _buildConnectButton(context),
    );
  }
}
