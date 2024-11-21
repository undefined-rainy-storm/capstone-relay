import 'package:relay/models/classes/serializables/connection_config.dart';

class JsonSerializedKeysConfig {
  static const connectionConfig = 'connection_config';
}

class Config {
  ConnectionConfig connectionConfig;
  Config({required this.connectionConfig});

  factory Config.fromJson(Map<String, dynamic> json) {
    return Config(
        connectionConfig: ConnectionConfig.fromJson(
            json[JsonSerializedKeysConfig.connectionConfig]));
  }

  Map<String, dynamic> toJson() => {
        JsonSerializedKeysConfig.connectionConfig: connectionConfig.toJson(),
      };
}
