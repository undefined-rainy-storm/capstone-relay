import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:relay/screens/entry.dart';

@widgetbook.UseCase(name: 'Default', type: EntryScreen)
Widget defaultUseCase(BuildContext context) {
  return const EntryScreen();
}
