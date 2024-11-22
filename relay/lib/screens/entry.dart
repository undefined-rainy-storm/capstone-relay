import 'package:flutter/material.dart';
import 'package:relay/widgets/entry/device_connection_overview.dart';

class EntryScreen extends StatefulWidget {
  const EntryScreen({super.key});

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        DeviceConnectionOverviewWidget(),
      ],
    )));
  }
}
