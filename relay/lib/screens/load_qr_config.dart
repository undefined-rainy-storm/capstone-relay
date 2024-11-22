import 'package:flutter/material.dart';

class LoadQrConfigScreen extends StatelessWidget {
  const LoadQrConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: SafeArea(
            child: Column(
      children: <Widget>[
        Text('Load QR Config'),
      ],
    )));
  }
}
