import 'package:relay/models/classes/extensions/json_serialized_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:relay/models/classes/serializables/config.dart';

class JsonSerializedKeysConnectionConfig {
  static const glassRemoteId = 'glass_remote_id';
  static const processorAddress = 'processor_address';
}

class ConnectionConfig {
  String glassRemoteId;
  String processorAddress;

  ConnectionConfig(
      {required this.glassRemoteId, required this.processorAddress});

  static Future<ConnectionConfig> fromSharedPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return ConnectionConfig(
      glassRemoteId: prefs.getString(jsonSerializedKeyConfig
              .appendChild(JsonSerializedKeysConfig.connectionConfig)
              .appendChild(JsonSerializedKeysConnectionConfig.glassRemoteId)) ??
          '',
      processorAddress: prefs.getString(jsonSerializedKeyConfig
              .appendChild(JsonSerializedKeysConfig.connectionConfig)
              .appendChild(
                  JsonSerializedKeysConnectionConfig.processorAddress)) ??
          '',
    );
  }

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) {
    return ConnectionConfig(
      glassRemoteId: json[JsonSerializedKeysConnectionConfig.glassRemoteId],
      processorAddress:
          json[JsonSerializedKeysConnectionConfig.processorAddress],
    );
  }

  Map<String, dynamic> toJson() => {
        JsonSerializedKeysConnectionConfig.glassRemoteId: glassRemoteId,
        JsonSerializedKeysConnectionConfig.processorAddress: processorAddress,
      };
}
