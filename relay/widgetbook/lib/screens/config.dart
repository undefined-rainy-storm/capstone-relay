import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:relay/screens/config.dart';

@widgetbook.UseCase(name: 'Default', type: ConfigScreen)
Widget defaultUseCase(BuildContext context) {
  return const ConfigScreen();
}
