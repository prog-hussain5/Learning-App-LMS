import 'package:flutter/services.dart';

class ScreenGuardIOS {
  static const _channel = MethodChannel('screen_guard');

  static Future<void> start() => _channel.invokeMethod('start');
  static Future<void> stop() => _channel.invokeMethod('stop');
}
