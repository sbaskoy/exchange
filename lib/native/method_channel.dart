import 'package:flutter/services.dart';

class NativeChannel {
  static const MethodChannel _channel = MethodChannel('com.sbaskoy.exchange/exchange');
  static Future<void> start() async {
    await _channel.invokeMethod('startService');
  }

  static Future<void> stop() async {
    await _channel.invokeMethod('stopService');
  }
}
