package com.example.consys_gertec_plugin.Scanner

import android.app.Activity
import android.content.Intent
import android.os.Bundle
import android.util.Log
import br.com.gertec.easylayer.codescanner.CodeScanner
import br.com.gertec.easylayer.codescanner.ScanConfig

class CodeScannerActivity : Activity() {

    private lateinit var scanner: CodeScanner

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        scanner = CodeScanner.getInstance(this)

        try {
            val scanConfig = ScanConfig()
            scanConfig.isBeepEnabled = true
            scanConfig.timeout = 20000 // 20 seconds timeout
            scanConfig.label = "Scan QR Code or Barcode"

            // This will start the scanner activity
            scanner.scanCode(this, scanConfig, CodeScanner.EAN_13) // QR_CODE / ALL_CODE_TYPES
        } catch (e: Exception) {
            Log.e("CodeScanner", "Error starting scanner", e)
            setResult(Activity.RESULT_CANCELED)
            finish()
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        
        Log.d("CodeScanner", "onActivityResult: requestCode=$requestCode, resultCode=$resultCode")
        
        if (resultCode == Activity.RESULT_OK && data != null) {
            // Log all extras to find the correct key
            val extras = data.extras
            if (extras != null) {
                for (key in extras.keySet()) {
                    Log.d("CodeScanner", "Extra key: $key = ${extras.get(key)}")
                }
            }
            
            // Try different possible keys that Gertec might use
            val content = data.getStringExtra("SCAN_RESULT") 
                ?: data.getStringExtra("barcode")
                ?: data.getStringExtra("code")
                ?: data.getStringExtra("result")
                ?: data.getStringExtra("content")
            
            if (content != null) {
                Log.d("CodeScanner", "Barcode scanned: $content")
                
                val resultIntent = Intent()
                resultIntent.putExtra("content", content)
                setResult(Activity.RESULT_OK, resultIntent)
            } else {
                Log.d("CodeScanner", "Scan cancelled - no content found")
                setResult(Activity.RESULT_CANCELED)
            }
        } else {
            Log.d("CodeScanner", "Scan cancelled or failed")
            setResult(Activity.RESULT_CANCELED)
        }
        
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        try {
            scanner.stopService()
        } catch (e: Exception) {
            Log.e("CodeScanner", "Error stopping scanner service", e)
        }
    }
}