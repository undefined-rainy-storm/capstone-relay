import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:relay/l10n/app_localizations.dart';

import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/consts/global_keys.dart' as globalKeys;

class LoadQrConfigScreen extends StatefulWidget {
  const LoadQrConfigScreen({super.key});

  @override
  State<LoadQrConfigScreen> createState() => _LoadQrConfigScreenState();
}

class _LoadQrConfigScreenState extends State<LoadQrConfigScreen> {
  QRViewController? controller;
  String qrParsed = '';

  void _onQRViewCreated(QRViewController controller, BuildContext context) {
    setState(() {
      controller = controller;
    });

    controller.scannedDataStream.listen((scanData) {
      if (scanData.code.runtimeType != String) {
        return;
      }

      try {
        Config parsed = Config.fromJson(jsonDecode(scanData.code!));
        GetIt.I.unregister<Config>();
        GetIt.I.registerSingleton<Config>(parsed);
      } on TypeError {
        return;
      } on FormatException {
        return;
      }

      if (context.mounted) {
        Navigator.pop(context);
      }
    });
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
            Expanded(
                flex: 5,
                child: QRView(
                  key: GlobalKey(
                      debugLabel: globalKeys.LoadQrConfigScreen.qrViewKey),
                  onQRViewCreated: (controller) =>
                      _onQRViewCreated(controller, context),
                )),
            Expanded(
                flex: 1,
                child: Center(
                    child: Text(qrParsed.isNotEmpty
                        ? [
                            AppLocalizations.of(context)!
                                .loadQrConfigScreen_qrCodeResult(qrParsed),
                            qrParsed
                          ].join('\n')
                        : AppLocalizations.of(context)!
                            .loadQrConfigScreen_qrCodeResultIsEmpty))),
          ],
        )));
  }
}
