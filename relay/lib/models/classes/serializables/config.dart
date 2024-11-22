import 'package:relay/models/classes/serializables/connection_config.dart';

const String jsonSerializedKeyConfig = 'config';

class JsonSerializedKeysConfig {
  static const connectionConfig = 'connection_config';
}

class Config {
  ConnectionConfig connectionConfig;

  Config({required this.connectionConfig});

  static Future<Config> fromSharedPrefs() async {
    return Config(
      connectionConfig: await ConnectionConfig.fromSharedPrefs(),
    );
  }

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
        connectionConfig: ConnectionConfig.fromJson(
            json[JsonSerializedKeysConfig.connectionConfig]));
  }

  Map<String, dynamic> toJson() => {
        JsonSerializedKeysConfig.connectionConfig: connectionConfig.toJson(),
      };
}
