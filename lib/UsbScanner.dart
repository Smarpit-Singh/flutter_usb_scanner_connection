import 'package:flutter/services.dart';

class UsbScanner {
  static const MethodChannel _methodChannel = MethodChannel('usb_scanner');
  static const EventChannel _eventChannel = EventChannel('usb_scanner_events');

  static Future<void> listen() async {
    try {
      await _methodChannel.invokeMethod('listen');
    } on PlatformException catch (e) {
      print('Error: ${e.message}');
    }
  }

  static Stream<dynamic> get events => _eventChannel.receiveBroadcastStream();
}