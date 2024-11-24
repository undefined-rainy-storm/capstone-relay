import 'package:flutter/material.dart';

import 'package:relay/l10n/app_localizations.dart';
import 'package:relay/models/enums/connection_status.dart';
import 'package:relay/models/classes/device.dart';
import 'package:relay/consts/styles.dart' as styles;

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
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: <Widget>[
          Text(
            widget.target.name,
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.left,
          ),
          const SizedBox(width: 8),
          Chip(
              avatar: Icon(
                Icons.fiber_manual_record,
                color: switch (widget.connectionStatus) {
                  ConnectionStatus.connected =>
                    styles.ConnectionStateWidget.chipColorConnected,
                  ConnectionStatus.connecting =>
                    styles.ConnectionStateWidget.chipColorConnecting,
                  ConnectionStatus.disconnected =>
                    styles.ConnectionStateWidget.chipColorDisconnected,
                  ConnectionStatus.timeout =>
                    styles.ConnectionStateWidget.chipColorTimeout,
                  _ => styles.ConnectionStateWidget.chipColorDisconnected
                },
              ),
              label: Text(switch (widget.connectionStatus) {
                ConnectionStatus.connected =>
                  AppLocalizations.of(context)!.enumConnectionStateConnected,
                ConnectionStatus.connecting =>
                  AppLocalizations.of(context)!.enumConnectionStateConnecting,
                ConnectionStatus.disconnected =>
                  AppLocalizations.of(context)!.enumConnectionStateDisconnected,
                ConnectionStatus.timeout =>
                  AppLocalizations.of(context)!.enumConnectionStateTimeout,
                _ => AppLocalizations.of(context)!.enumConnectionStateError
              })),
        ]),
        const SizedBox(height: 3),
        Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.target.address,
              textAlign: TextAlign.left,
            )),
      ],
    ));
  }
}
