import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'consys_gertec_plugin_method_channel.dart';

abstract class ConsysGertecPluginPlatform extends PlatformInterface {
  /// Constructs a ConsysGertecPluginPlatform.
  ConsysGertecPluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static ConsysGertecPluginPlatform _instance = MethodChannelConsysGertecPlugin();

  /// The default instance of [ConsysGertecPluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelConsysGertecPlugin].
  static ConsysGertecPluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [ConsysGertecPluginPlatform] when
  /// they register themselves.
  static set instance(ConsysGertecPluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> scanBarcode() {
    throw UnimplementedError('scanBarcode() has not been implemented.');
  }

  Future<bool> printText({
    required String text,
    String alignment = 'LEFT', // LEFT, CENTER, RIGHT
    int fontSize = 24,
    bool isBold = false,
  }) {
    throw UnimplementedError('printText() has not been implemented.');
  }

  Future<bool> cutPaper() {
    throw UnimplementedError('cutPaper() has not been implemented.');
  }

  Future<bool> feedPaper({int lines = 10}) {
    throw UnimplementedError('feedPaper() has not been implemented.');
  }

  Future<bool> printQRCode({
    required String qrCodeData,
    String size = 'FULL', // FULL, HALF, QUARTER
  }) {
    throw UnimplementedError('printQRCode() has not been implemented.');
  }
}