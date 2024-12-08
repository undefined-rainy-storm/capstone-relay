import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;
import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:relay/models/classes/serializables/config.dart';
import 'package:relay/providers/config_provider.dart';

import 'package:relay/widgets/select_ble_device/descriptor_tile.dart';

class CharacteristicTile extends StatefulWidget {
  final BluetoothDevice device;
  final BluetoothService service;
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const CharacteristicTile(
      {super.key,
      required this.device,
      required this.service,
      required this.characteristic,
      required this.descriptorTiles});

  @override
  State<CharacteristicTile> createState() => _CharacteristicTileState();
}

class _CharacteristicTileState extends State<CharacteristicTile> {
  List<int> _lastValue = [];
  Timer? _readTimer;
  static const _readInterval = Duration(milliseconds: 25);

  @override
  void initState() {
    super.initState();
    _startPeriodicRead();
  }

  @override
  void dispose() {
    _readTimer?.cancel();
    super.dispose();
  }

  void _startPeriodicRead() {
    /*
    _readTimer = Timer.periodic(_readInterval, (timer) async {
      log('asdf');
      if (c.properties.read) {
        try {
          await onReadPressed();
          setState(() {
            _lastValue = c.lastValue;
            log('Periodic read: $_lastValue');
          });
        } catch (e) {
          developer.log('Periodic read error: $e');
        }
      }
    });*/
  }

  Widget _buildValue() {
    if (_lastValue == null) return Text('No value');

    return Text(
      'Value: ${String.fromCharCodes(_lastValue!)}',
      style: TextStyle(
        fontSize: 14,
        color: Colors.blue,
      ),
    );
  }

  BluetoothCharacteristic get c => widget.characteristic;

  List<int> _getRandomBytes() {
    final _math = math.Random();
    return [
      _math.nextInt(255),
      _math.nextInt(255),
      _math.nextInt(255),
      _math.nextInt(255)
    ];
  }

  Future onReadPressed() async {
    try {
      await c.read();
      developer.log('Read: Success');
    } catch (e) {
      developer.log('Read Error: $e');
    }
  }

  void onSelectPressed(BuildContext context) {
    Config config = context.read<ConfigProvider>().config;
    config.device = widget.device;
    config.service = widget.service;
    config.characteristic = widget.characteristic;
    Navigator.of(context).pop();
  }

  Future onWritePressed() async {
    try {
      await c.write(_getRandomBytes(),
          withoutResponse: c.properties.writeWithoutResponse);
      developer.log('Write: Success');
      if (c.properties.read) {
        await c.read();
      }
    } catch (e) {
      developer.log('Write Error: $e');
    }
  }

  Future onSubscribePressed() async {
    try {
      String op = c.isNotifying == false ? 'Subscribe' : 'Unubscribe';
      await c.setNotifyValue(c.isNotifying == false);
      developer.log('$op : Success');
      if (c.properties.read) {
        await c.read();
      }
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      developer.log('Subscribe Error: $e');
    }
  }

  Widget buildUuid(BuildContext context) {
    String uuid = '0x${widget.characteristic.uuid.str.toUpperCase()}';
    return Text(uuid, style: TextStyle(fontSize: 13));
  }

  Widget buildSelectButton(BuildContext context) {
    return TextButton(
        child: Text('Select'),
        onPressed: () async {
          onSelectPressed(context);
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildReadButton(BuildContext context) {
    return TextButton(
        child: Text('Read'),
        onPressed: () async {
          await onReadPressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildWriteButton(BuildContext context) {
    bool withoutResp = widget.characteristic.properties.writeWithoutResponse;
    return TextButton(
        child: Text(withoutResp ? 'WriteNoResp' : 'Write'),
        onPressed: () async {
          await onWritePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildSubscribeButton(BuildContext context) {
    bool isNotifying = widget.characteristic.isNotifying;
    return TextButton(
        child: Text(isNotifying ? 'Unsubscribe' : 'Subscribe'),
        onPressed: () async {
          await onSubscribePressed();
          if (mounted) {
            setState(() {});
          }
        });
  }

  Widget buildButtonRow(BuildContext context) {
    bool read = widget.characteristic.properties.read;
    bool write = widget.characteristic.properties.write;
    bool notify = widget.characteristic.properties.notify;
    bool indicate = widget.characteristic.properties.indicate;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        buildSelectButton(context),
        if (read) buildReadButton(context),
        if (write) buildWriteButton(context),
        if (notify || indicate) buildSubscribeButton(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: ListTile(
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Characteristic'),
            buildUuid(context),
            _buildValue(),
          ],
        ),
        subtitle: buildButtonRow(context),
        contentPadding: const EdgeInsets.all(0.0),
      ),
      children: widget.descriptorTiles,
    );
  }
}
