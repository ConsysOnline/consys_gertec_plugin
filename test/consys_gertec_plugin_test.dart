import 'package:flutter_test/flutter_test.dart';
import 'package:consys_gertec_plugin/consys_gertec_plugin.dart';
import 'package:consys_gertec_plugin/consys_gertec_plugin_platform_interface.dart';
import 'package:consys_gertec_plugin/consys_gertec_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockConsysGertecPluginPlatform
    with MockPlatformInterfaceMixin
    implements ConsysGertecPluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Future<String?> scanBarcode() => Future.value('7896004711287');

  @override
  Future<bool> printText({
    required String text,
    String alignment = 'LEFT', // LEFT, CENTER, RIGHT
    int fontSize = 20,
    bool isBold = false,
  }) => Future.value(true);

  @override
  Future<bool> cutPaper() => Future.value(true);

  @override
  Future<bool> feedPaper({int lines = 10}) => Future.value(true);

  @override
  Future<bool> printQRCode({
    required String qrCodeData,
    String size = 'HALF', // FULL, HALF, QUARTER
  }) => Future.value(true);
}

void main() {
  final ConsysGertecPluginPlatform initialPlatform = ConsysGertecPluginPlatform.instance;

  test('$MethodChannelConsysGertecPlugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelConsysGertecPlugin>());
  });

  test('scanBarcode', () async {
    ConsysGertecPlugin consysGertecPlugin = ConsysGertecPlugin();
    MockConsysGertecPluginPlatform fakePlatform = MockConsysGertecPluginPlatform();
    ConsysGertecPluginPlatform.instance = fakePlatform;

    expect(await consysGertecPlugin.scanBarcode(), '7896004711287');
  });
}
