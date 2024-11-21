class InvalidSerializedEnumException implements Exception {
  String enumType;
  String value;
  InvalidSerializedEnumException({this.enumType = '', this.value = ''});

  @override
  String toString() {
    return 'InvalidSerializedEnumException: <$enumType>$value';
  }
}
