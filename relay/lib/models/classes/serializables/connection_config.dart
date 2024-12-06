import 'package:relay/models/classes/extensions/json_serialized_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:relay/consts/defaults.dart' as defaults;
import 'package:relay/consts/serialized_keys.dart' as sk;

class ConnectionConfig {
  String glassCachedName;
  String glassServiceUUID;
  String glassCharacteristicUUID;
  String processorName;
  String processorAddress;

  ConnectionConfig(
      {required this.glassCachedName,
      required this.glassServiceUUID,
      required this.glassCharacteristicUUID,
      required this.processorName,
      required this.processorAddress});

  static Future<ConnectionConfig> fromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return ConnectionConfig(
      glassCachedName: prefs.getString(sk.config
              .appendChild(sk.Config.connectionConfig)
              .appendChild(sk.ConnectionConfig.glassCachedName)) ??
          defaults.ConnectionConfig.glassCachedName,
      glassServiceUUID: prefs.getString(sk.config
              .appendChild(sk.Config.connectionConfig)
              .appendChild(sk.ConnectionConfig.glassServiceUUID)) ??
          defaults.ConnectionConfig.glassRemoteId,
      glassCharacteristicUUID: prefs.getString(sk.config
              .appendChild(sk.Config.connectionConfig)
              .appendChild(sk.ConnectionConfig.glassCharacteristicUUID)) ??
          defaults.ConnectionConfig.glassRemoteId,
      processorName: prefs.getString(sk.config
              .appendChild(sk.Config.connectionConfig)
              .appendChild(sk.ConnectionConfig.processorName)) ??
          defaults.ConnectionConfig.processorName,
      processorAddress: prefs.getString(sk.config
              .appendChild(sk.Config.connectionConfig)
              .appendChild(sk.ConnectionConfig.processorAddress)) ??
          defaults.ConnectionConfig.processorAddress,
    );
  }

  Future<void> saveToSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        sk.config
            .appendChild(sk.Config.connectionConfig)
            .appendChild(sk.ConnectionConfig.glassCachedName),
        glassCachedName);
    await prefs.setString(
        sk.config
            .appendChild(sk.Config.connectionConfig)
            .appendChild(sk.ConnectionConfig.glassServiceUUID),
        glassServiceUUID);
    await prefs.setString(
        sk.config
            .appendChild(sk.Config.connectionConfig)
            .appendChild(sk.ConnectionConfig.glassCharacteristicUUID),
        glassCharacteristicUUID);
    await prefs.setString(
        sk.config
            .appendChild(sk.Config.connectionConfig)
            .appendChild(sk.ConnectionConfig.processorName),
        processorName);
    await prefs.setString(
        sk.config
            .appendChild(sk.Config.connectionConfig)
            .appendChild(sk.ConnectionConfig.processorAddress),
        processorAddress);
  }

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) {
    return ConnectionConfig(
      glassCachedName: json[sk.ConnectionConfig.glassCachedName],
      glassServiceUUID: json[sk.ConnectionConfig.glassServiceUUID],
      glassCharacteristicUUID:
          json[sk.ConnectionConfig.glassCharacteristicUUID],
      processorName: json[sk.ConnectionConfig.processorName],
      processorAddress: json[sk.ConnectionConfig.processorAddress],
    );
  }

  Map<String, dynamic> toJson() => {
        sk.ConnectionConfig.glassCachedName: glassCachedName,
        sk.ConnectionConfig.glassServiceUUID: glassServiceUUID,
        sk.ConnectionConfig.glassCharacteristicUUID: glassCharacteristicUUID,
        sk.ConnectionConfig.processorName: processorName,
        sk.ConnectionConfig.processorAddress: processorAddress,
      };
}
