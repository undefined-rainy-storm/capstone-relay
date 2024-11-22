// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_import, prefer_relative_imports, directives_ordering

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AppGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:widgetbook/widgetbook.dart' as _i1;
import 'package:widgetbook_workspace/screens/config.dart' as _i2;
import 'package:widgetbook_workspace/screens/entry.dart' as _i3;
import 'package:widgetbook_workspace/screens/select_ble_device.dart' as _i4;
import 'package:widgetbook_workspace/widgets/connection_state.dart' as _i5;

final directories = <_i1.WidgetbookNode>[
  _i1.WidgetbookFolder(
    name: 'screens',
    children: [
      _i1.WidgetbookLeafComponent(
        name: 'ConfigScreen',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i2.defaultUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'EntryScreen',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i3.defaultUseCase,
        ),
      ),
      _i1.WidgetbookLeafComponent(
        name: 'SelectBleDeviceScreen',
        useCase: _i1.WidgetbookUseCase(
          name: 'Default',
          builder: _i4.defaultUseCase,
        ),
      ),
    ],
  ),
  _i1.WidgetbookFolder(
    name: 'widgets',
    children: [
      _i1.WidgetbookComponent(
        name: 'ConnectionStateWidget',
        useCases: [
          _i1.WidgetbookUseCase(
            name: 'Default',
            builder: _i5.defaultUseCase,
          ),
          _i1.WidgetbookUseCase(
            name: 'Disconnected',
            builder: _i5.disconnectedUseCase,
          ),
        ],
      )
    ],
  ),
];
