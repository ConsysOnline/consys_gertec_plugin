import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:consys_gertec_plugin/consys_gertec_plugin_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelConsysGertecPlugin platform = MethodChannelConsysGertecPlugin();
  const MethodChannel channel = MethodChannel('consys_gertec_plugin');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });

  test('scanBarcode', () async {
    expect(await platform.scanBarcode(), '7896004711287');
  });
}
