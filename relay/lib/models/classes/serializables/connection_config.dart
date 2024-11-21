class JsonSerializedKeysConnectionConfig {
  static const glassRemoteId = 'glass_remote_id';
}

class ConnectionConfig {
  String glassRemoteId;
  ConnectionConfig({required this.glassRemoteId});

  factory ConnectionConfig.fromJson(Map<String, dynamic> json) {
    return ConnectionConfig(
        glassRemoteId: json[JsonSerializedKeysConnectionConfig.glassRemoteId]);
  }

  Map<String, dynamic> toJson() => {
        JsonSerializedKeysConnectionConfig.glassRemoteId: glassRemoteId,
      };
}
