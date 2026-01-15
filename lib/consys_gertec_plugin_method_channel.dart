import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'consys_gertec_plugin_platform_interface.dart';

/// An implementation of [ConsysGertecPluginPlatform] that uses method channels.
class MethodChannelConsysGertecPlugin extends ConsysGertecPluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('consys_gertec_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    debugPrint('MethodChannel: Invoking getPlatformVersion');
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    debugPrint('MethodChannel: getPlatformVersion result: $version');
    return version;
  }

  @override
  Future<String?> scanBarcode() async {
    try {
      debugPrint('MethodChannel: Invoking scanBarcode');
      final String? result =
          await methodChannel.invokeMethod<String>('scanBarcode');
      debugPrint('MethodChannel: scanBarcode result: $result');
      return result;
    } on PlatformException catch (e) {
      throw Exception('Barcode scan failed: ${e.message}');
    }
  }

  @override
  Future<bool> printText({
    required String text,
    String alignment = 'LEFT', // LEFT, CENTER, RIGHT
    int fontSize = 24,
    bool isBold = false,
  }) async {
    debugPrint('MethodChannel: printText CALLED with:');
    debugPrint('  - text: $text');
    debugPrint('  - alignment: $alignment');
    debugPrint('  - fontSize: $fontSize');
    debugPrint('  - isBold: $isBold');
    
    try {
      final params = {
        'text': text,
        'alignment': alignment,
        'fontSize': fontSize,
        'isBold': isBold,
      };
      debugPrint('MethodChannel: Invoking printText with params: $params');
      final bool? result = await methodChannel.invokeMethod<bool>('printText', params);
      debugPrint('MethodChannel: printText result: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Print failed: ${e.message}');
    }
  }

  @override
  Future<bool> cutPaper() async {
    try {
      debugPrint('MethodChannel: Invoking cutPaper');
      final bool? result = await methodChannel.invokeMethod<bool>('cutPaper');
      debugPrint('MethodChannel: cutPaper result: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Cut paper failed: ${e.message}');
    }
  }

  @override  
  Future<bool> feedPaper({int lines = 10}) async {
    debugPrint('MethodChannel: feedPaper CALLED with lines: $lines');
    
    try {
      final params = {
        'lines': lines,
      };
      debugPrint('MethodChannel: Invoking feedPaper with params: $params');
      final bool? result = await methodChannel.invokeMethod<bool>('feedPaper', params);
      debugPrint('MethodChannel: feedPaper result: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Feed paper failed: ${e.message}');
    }
  }

  @override
  Future<bool> printQRCode({
    required String qrCodeData,
    String size = 'FULL', // FULL, HALF, QUARTER
  }) async {
    debugPrint('MethodChannel: printQRCode CALLED with:');
    debugPrint('  - qrCodeData: $qrCodeData');
    debugPrint('  - size: $size');
    
    try {
      final params = {
        'qrCodeData': qrCodeData,
        'size': size,
      };
      debugPrint('MethodChannel: Invoking printQRCode with params: $params');
      final bool? result = await methodChannel.invokeMethod<bool>('printQRCode', params);
      debugPrint('MethodChannel: printQRCode result: $result');
      return result ?? false;
    } on PlatformException catch (e) {
      throw Exception('Print QR code failed: ${e.message}');
    }
  }
}