import 'consys_gertec_plugin_platform_interface.dart';

class ConsysGertecPlugin {
  Future<String?> scanBarcode() {
    return ConsysGertecPluginPlatform.instance.scanBarcode();
  }

  Future<bool> printText({
    required String text,
    String alignment = 'LEFT', // LEFT, CENTER, RIGHT
    int fontSize = 24,
    bool isBold = false,
  }) {
    return ConsysGertecPluginPlatform.instance.printText(
      text: text,
      alignment: alignment,
      fontSize: fontSize,
      isBold: isBold,
    );
  }

  Future<bool> cutPaper() async {
    return ConsysGertecPluginPlatform.instance.cutPaper();
  }

  /// Feed paper (scroll empty lines)
  /// [lines] - number of lines to feed (default: 10)
  Future<bool> feedPaper({int lines = 10}) async {
    return ConsysGertecPluginPlatform.instance.feedPaper(lines: lines);
  }

  /// Print QR Code
  /// [qrCodeData] - the data/URL to encode in the QR code
  /// [size] - QR code size: 'FULL', 'HALF', or 'QUARTER' (default: 'FULL')
  Future<bool> printQRCode({
    required String qrCodeData,
    String size = 'FULL', // FULL, HALF, QUARTER
  }) async {
    return ConsysGertecPluginPlatform.instance.printQRCode(
      qrCodeData: qrCodeData,
      size: size,
    );
  }
}