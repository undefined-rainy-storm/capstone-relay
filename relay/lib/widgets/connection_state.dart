import 'package:flutter/material.dart';

import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:relay/models/classes/device.dart';

class ConnectionStateWidget extends StatefulWidget {
  final Device target;
  final ConnectionStatus connectionStatus;
  const ConnectionStateWidget(
      {super.key, required this.target, required this.connectionStatus});

  @override
  State<ConnectionStateWidget> createState() => _ConnectionStateWidgetState();
}

class _ConnectionStateWidgetState extends State<ConnectionStateWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(widget.target.name, style: TextStyle(fontSize: 16)),
              const SizedBox(width: 8),
              Chip(
                  avatar: Icon(
                    Icons.fiber_manual_record,
                    color: widget.connectionStatus == ConnectionStatus.connected
                        ? Colors.green
                        : Colors.red,
                  ),
                  label: Text(switch (widget.connectionStatus) {
                    ConnectionStatus.connected => AppLocalizations.of(context)!
                        .enumConnectionStateConnected,
                    ConnectionStatus.connecting => AppLocalizations.of(context)!
                        .enumConnectionStateConnecting,
                    ConnectionStatus.disconnected =>
                      AppLocalizations.of(context)!
                          .enumConnectionStateDisconnected,
                    ConnectionStatus.timeout =>
                      AppLocalizations.of(context)!.enumConnectionStateTimeout,
                    _ => AppLocalizations.of(context)!.enumConnectionStateError
                  })),
            ]),
        const SizedBox(height: 3),
        Text(widget.target.address),
      ],
    ));
  }
}
