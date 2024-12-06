import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String SERVICE_UUID = "19B10000-E8F2-537E-4F6C-D104768A1214";
const String CHARACTERISTIC_UUID = "19B10001-E8F2-537E-4F6C-D104768A1214";

class BluetoothBackgroundService {
  static Future<void> initializeService() async {
    final service = FlutterBackgroundService();

    // Initialize notifications for background service
    await initializeNotifications();

    await service.configure(
      androidConfiguration: AndroidConfiguration(
        onStart: onStart,
        autoStart: true,
        isForegroundMode: true,
        notificationChannelId: 'bluetooth_service',
        initialNotificationTitle: 'Bluetooth Service',
        initialNotificationContent: 'Running in background',
        foregroundServiceNotificationId: 888,
      ),
      iosConfiguration: IosConfiguration(
        autoStart: true,
        onForeground: onStart,
        onBackground: onIosBackground,
      ),
    );
  }

  static Future<void> initializeNotifications() async {
    final FlutterLocalNotificationsPlugin notifications =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    await notifications.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );
  }
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  String targetDeviceId = await getStoredDeviceId();
  BluetoothDevice? device;
  StreamSubscription? connectionStateSubscription;

  // Keep the service running
  while (true) {
    try {
      if (device == null || device.state == BluetoothDeviceState.disconnected) {
        device = BluetoothDevice.fromId(targetDeviceId);

        // Setup connection state listener
        connectionStateSubscription?.cancel();
        connectionStateSubscription = device.state.listen((state) {
          service.invoke(
            'connectionState',
            {'state': state.toString()},
          );
        });

        // Connect to device
        await device.connect(timeout: Duration(seconds: 30));

        // Discover services
        List<BluetoothService> services = await device.discoverServices();

        // Find our service and characteristic
        for (BluetoothService bleService in services) {
          if (bleService.uuid.toString() == SERVICE_UUID) {
            for (BluetoothCharacteristic characteristic
                in bleService.characteristics) {
              if (characteristic.uuid.toString() == CHARACTERISTIC_UUID) {
                // Enable notifications
                await characteristic.setNotifyValue(true);

                // Listen to notifications
                characteristic.value.listen((value) async {
                  // Process received data
                  await processReceivedData(value, service);
                });
              }
            }
          }
        }
      }

      // Wait before checking connection again
      await Future.delayed(Duration(seconds: 5));
    } catch (e) {
      print('Background service error: $e');
      await Future.delayed(Duration(seconds: 30)); // Wait before retrying
    }
  }
}

Future<void> processReceivedData(
    List<int> data, ServiceInstance service) async {
  try {
    // Convert data as needed
    String stringValue = String.fromCharCodes(data);

    // Store data locally
    final prefs = await SharedPreferences.getInstance();
    List<String> storedData = prefs.getStringList('bluetooth_data') ?? [];
    storedData.add('${DateTime.now().toIso8601String()}: $stringValue');
    await prefs.setStringList('bluetooth_data', storedData);

    // Send data to main app
    service.invoke(
      'dataReceived',
      {
        'data': stringValue,
        'timestamp': DateTime.now().toIso8601String(),
      },
    );

    // Show notification if needed
    await showNotification(stringValue);
  } catch (e) {
    print('Data processing error: $e');
  }
}

Future<void> showNotification(String data) async {
  final FlutterLocalNotificationsPlugin notifications =
      FlutterLocalNotificationsPlugin();

  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'bluetooth_channel',
    'Bluetooth Updates',
    importance: Importance.high,
    priority: Priority.high,
  );

  const NotificationDetails details = NotificationDetails(
    android: androidDetails,
    iOS: DarwinNotificationDetails(),
  );

  await notifications.show(
    0,
    'New Bluetooth Data',
    data,
    details,
  );
}

Future<String> getStoredDeviceId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('target_device_id') ?? '';
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  return true;
}
