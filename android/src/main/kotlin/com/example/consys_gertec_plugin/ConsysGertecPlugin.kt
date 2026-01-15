package com.example.consys_gertec_plugin

import android.app.Activity
import android.content.Intent
import android.util.Log
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import com.example.consys_gertec_plugin.Scanner.CodeScannerActivity
import com.example.consys_gertec_plugin.Printer.PrinterActivity

class ConsysGertecPlugin : FlutterPlugin, MethodChannel.MethodCallHandler, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var pendingResult: MethodChannel.Result? = null

    companion object {
        const val REQUEST_SCAN = 9001
        const val REQUEST_PRINT = 9002
        private const val TAG = "ConsysGertecPlugin"
    }

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(binding.binaryMessenger, "consys_gertec_plugin")
        channel.setMethodCallHandler(this)
        Log.d(TAG, "Plugin attached to engine")
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        Log.d(TAG, "Plugin detached from engine")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
        Log.d(TAG, "Plugin attached to activity")

        binding.addActivityResultListener { requestCode, resultCode, data ->
            Log.d(TAG, "Activity result received - requestCode: $requestCode, resultCode: $resultCode")
            
            if (requestCode == REQUEST_SCAN) {
                if (pendingResult != null) {
                    if (resultCode == Activity.RESULT_OK && data != null) {
                        val content = data.getStringExtra("content")
                        Log.d(TAG, "Scan successful: $content")
                        pendingResult?.success(content)
                    } else {
                        Log.e(TAG, "Scan failed")
                        pendingResult?.error("SCAN_FAILED", "No barcode scanned", null)
                    }
                    pendingResult = null
                }
                true
            } else if (requestCode == REQUEST_PRINT) {
                if (pendingResult != null) {
                    if (resultCode == Activity.RESULT_OK) {
                        Log.d(TAG, "Print successful")
                        pendingResult?.success(true)
                    } else if (resultCode == Activity.RESULT_CANCELED && data != null) {
                        val error = data.getStringExtra("error") ?: "Print failed"
                        Log.e(TAG, "Print failed: $error")
                        pendingResult?.error("PRINT_FAILED", error, null)
                    } else {
                        Log.e(TAG, "Print operation failed")
                        pendingResult?.error("PRINT_FAILED", "Print operation failed", null)
                    }
                    pendingResult = null
                }
                true
            } else {
                false
            }
        }
    }

    override fun onDetachedFromActivity() { 
        activity = null
        Log.d(TAG, "Plugin detached from activity")
    }
    
    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) { 
        activity = binding.activity
        Log.d(TAG, "Plugin reattached to activity")
    }
    
    override fun onDetachedFromActivityForConfigChanges() { 
        activity = null
        Log.d(TAG, "Plugin detached from activity for config changes")
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        Log.d(TAG, "Method called: ${call.method}")
        
        when (call.method) {
            "scanBarcode" -> {
                val act = activity ?: run {
                    Log.e(TAG, "No activity available")
                    result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
                    return
                }

                pendingResult = result

                try {
                    val intent = Intent(act, CodeScannerActivity::class.java)
                    act.startActivityForResult(intent, REQUEST_SCAN)
                    Log.d(TAG, "Scan activity started")
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting scan activity", e)
                    pendingResult = null
                    result.error("SCAN_ERROR", e.message, null)
                }
            }
            
            "printText" -> {
                val act = activity ?: run {
                    Log.e(TAG, "No activity available")
                    result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
                    return
                }
                
                val text = call.argument<String>("text")
                val alignment = call.argument<String>("alignment") ?: "LEFT"
                val fontSize = call.argument<Int>("fontSize") ?: 24
                val isBold = call.argument<Boolean>("isBold") ?: false
                
                Log.d(TAG, "printText - text: $text, alignment: $alignment, fontSize: $fontSize, isBold: $isBold")
                
                if (text == null) {
                    Log.e(TAG, "Text is null")
                    result.error("INVALID_ARGUMENT", "Text is required", null)
                    return
                }
                
                pendingResult = result
                
                try {
                    val intent = Intent(act, PrinterActivity::class.java)
                    intent.putExtra("action", PrinterActivity.ACTION_PRINT_TEXT)
                    intent.putExtra("text", text)
                    intent.putExtra("alignment", alignment)
                    intent.putExtra("fontSize", fontSize)
                    intent.putExtra("isBold", isBold)
                    
                    Log.d(TAG, "Starting PrinterActivity with extras: ${intent.extras}")
                    act.startActivityForResult(intent, REQUEST_PRINT)
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting print activity", e)
                    pendingResult = null
                    result.error("PRINT_ERROR", e.message, null)
                }
            }
            
            "cutPaper" -> {
                val act = activity ?: run {
                    Log.e(TAG, "No activity available")
                    result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
                    return
                }
                
                Log.d(TAG, "cutPaper called")
                pendingResult = result
                
                try {
                    val intent = Intent(act, PrinterActivity::class.java)
                    intent.putExtra("action", PrinterActivity.ACTION_CUT_PAPER)
                    act.startActivityForResult(intent, REQUEST_PRINT)
                    Log.d(TAG, "Cut paper activity started")
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting cut paper activity", e)
                    pendingResult = null
                    result.error("CUT_PAPER_ERROR", e.message, null)
                }
            }
            
            "feedPaper" -> {
                val act = activity ?: run {
                    Log.e(TAG, "No activity available")
                    result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
                    return
                }
                
                val lines = call.argument<Int>("lines") ?: 10
                
                Log.d(TAG, "feedPaper called - lines: $lines")
                pendingResult = result
                
                try {
                    val intent = Intent(act, PrinterActivity::class.java)
                    intent.putExtra("action", PrinterActivity.ACTION_FEED_PAPER)
                    intent.putExtra("lines", lines)
                    act.startActivityForResult(intent, REQUEST_PRINT)
                    Log.d(TAG, "Feed paper activity started")
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting feed paper activity", e)
                    pendingResult = null
                    result.error("FEED_PAPER_ERROR", e.message, null)
                }
            }
            
            "printQRCode" -> {
                val act = activity ?: run {
                    Log.e(TAG, "No activity available")
                    result.error("NO_ACTIVITY", "Plugin not attached to an Activity", null)
                    return
                }
                
                val qrCodeData = call.argument<String>("qrCodeData")
                val size = call.argument<String>("size") ?: "HALF"
                
                Log.d(TAG, "printQRCode - qrCodeData: $qrCodeData, size: $size")
                
                if (qrCodeData == null) {
                    Log.e(TAG, "QR code data is null")
                    result.error("INVALID_ARGUMENT", "QR code data is required", null)
                    return
                }
                
                pendingResult = result
                
                try {
                    val intent = Intent(act, PrinterActivity::class.java)
                    intent.putExtra("action", PrinterActivity.ACTION_PRINT_QRCODE)
                    intent.putExtra("qrCodeData", qrCodeData)
                    intent.putExtra("size", size)
                    
                    Log.d(TAG, "Starting QR code print activity")
                    act.startActivityForResult(intent, REQUEST_PRINT)
                } catch (e: Exception) {
                    Log.e(TAG, "Error starting QR code activity", e)
                    pendingResult = null
                    result.error("QRCODE_ERROR", e.message, null)
                }
            }
            
            else -> {
                Log.d(TAG, "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }
}