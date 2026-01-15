import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:consys_gertec_plugin/consys_gertec_plugin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _scannedStr = 'No scan yet';
  String _lastAction = 'No action performed';
  bool _isLoading = false;
  final _consysGertecPlugin = ConsysGertecPlugin();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _scanBarcode() async {
    setState(() => _isLoading = true);
    
    try {
      final scannedStr = await _consysGertecPlugin.scanBarcode() ?? 'Invalid string';
      
      if (!mounted) return;
      
      setState(() {
        _scannedStr = scannedStr;
        _lastAction = 'Barcode scanned successfully';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _scannedStr = 'Scan failed';
        _lastAction = 'Error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<void> _printText() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await _consysGertecPlugin.printText(
        text: "Hello from Flutter!",
        alignment: "CENTER",
        fontSize: 24,
        isBold: true
      );
      
      if (!mounted) return;
      
      setState(() {
        _lastAction = success ? 'Text printed successfully' : 'Print failed';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'Print error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<void> _printQRCode() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await _consysGertecPlugin.printQRCode(
        qrCodeData: 'https://consultadfe.fazenda.rj.gov.br/consultaNFCe/QRCode?chNFe=i=323032362d30312d30395431363a32373a32342d30333a3030&vNF=17.40&vICMS=0.00',
        size: 'FULL',
      );
      
      if (!mounted) return;
      
      setState(() {
        _lastAction = success ? 'QR Code printed successfully' : 'QR Code print failed';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'QR Code error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<void> _feedPaper() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await _consysGertecPlugin.feedPaper(lines: 10);
      
      if (!mounted) return;
      
      setState(() {
        _lastAction = success ? 'Paper fed successfully' : 'Feed failed';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'Feed error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<void> _cutPaper() async {
    setState(() => _isLoading = true);
    
    try {
      final success = await _consysGertecPlugin.cutPaper();
      
      if (!mounted) return;
      
      setState(() {
        _lastAction = success ? 'Paper cut successfully' : 'Cut failed';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'Cut error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Future<void> _printFullReceipt() async {
    setState(() => _isLoading = true);
    
    try {
      // Print header
      await _consysGertecPlugin.printText(
        text: "CUPOM FISCAL",
        alignment: "CENTER",
        fontSize: 28,
        isBold: true,
      );
      
      // Print separator
      await _consysGertecPlugin.printText(
        text: "--------------------------------",
        alignment: "CENTER",
        fontSize: 20,
      );
      
      // Print items
      await _consysGertecPlugin.printText(
        text: "Item 1: R\$ 10,00",
        alignment: "LEFT",
        fontSize: 20,
      );
      
      await _consysGertecPlugin.printText(
        text: "Item 2: R\$ 15,00",
        alignment: "LEFT",
        fontSize: 20,
      );
      
      // Print total
      await _consysGertecPlugin.printText(
        text: "TOTAL: R\$ 25,00",
        alignment: "RIGHT",
        fontSize: 24,
        isBold: true,
      );
      
      // Print QR Code
      await _consysGertecPlugin.printQRCode(
        qrCodeData: 'https://gertec.com.br',
        size: 'HALF',
      );
      
      // Feed and cut
      await _consysGertecPlugin.feedPaper(lines: 10);
      await _consysGertecPlugin.cutPaper();
      
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'Full receipt printed successfully';
        _isLoading = false;
      });
    } on PlatformException catch (e) {
      if (!mounted) return;
      
      setState(() {
        _lastAction = 'Receipt error: ${e.message}';
        _isLoading = false;
      });
    }
  }

  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton.icon(
        onPressed: _isLoading ? null : onPressed,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey[300],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required String title, required String content, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!, width: 1),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[700], size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.blue[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text(
            'Gertec SK210 Controller',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: Colors.blue[700],
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Status Cards
                  _buildInfoCard(
                    title: 'Last Scanned Barcode',
                    content: _scannedStr,
                    icon: Icons.qr_code_scanner,
                  ),
                  const SizedBox(height: 12),
                  _buildInfoCard(
                    title: 'Last Action',
                    content: _lastAction,
                    icon: Icons.info_outline,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Scanner Section
                  Text(
                    'Scanner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildActionButton(
                    label: 'Scan Barcode',
                    icon: Icons.qr_code_scanner,
                    onPressed: _scanBarcode,
                    color: Colors.purple,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Printer Section
                  Text(
                    'Printer Actions',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    label: 'Print Text',
                    icon: Icons.text_fields,
                    onPressed: _printText,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    label: 'Print QR Code',
                    icon: Icons.qr_code,
                    onPressed: _printQRCode,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    label: 'Feed Paper',
                    icon: Icons.arrow_downward,
                    onPressed: _feedPaper,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    label: 'Cut Paper',
                    icon: Icons.content_cut,
                    onPressed: _cutPaper,
                    color: Colors.red,
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Demo Section
                  Text(
                    'Demo',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 12),
                  
                  _buildActionButton(
                    label: 'Print Full Receipt',
                    icon: Icons.receipt_long,
                    onPressed: _printFullReceipt,
                    color: Colors.indigo,
                  ),
                  
                  const SizedBox(height: 20),
                ],
              ),
            ),
            
            // Loading Overlay
            if (_isLoading)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text(
                            'Processing...',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}