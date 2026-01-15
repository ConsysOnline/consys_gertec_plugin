package com.example.consys_gertec_plugin.Printer

import android.app.Activity
import android.content.Intent
import android.graphics.Bitmap
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.util.Log
import br.com.gertec.easylayer.printer.Printer
import br.com.gertec.easylayer.printer.PrinterError
import br.com.gertec.easylayer.printer.TextFormat
import br.com.gertec.easylayer.printer.Alignment
import br.com.gertec.easylayer.printer.BarcodeFormat
import br.com.gertec.easylayer.printer.BarcodeType
import br.com.gertec.easylayer.printer.CutType

class PrinterActivity : Activity(), Printer.Listener {

    private lateinit var printer: Printer
    private var printSuccess = false
    private var isPrinting = false
    private val handler = Handler(Looper.getMainLooper())

    companion object {
        const val ACTION_PRINT_TEXT = "print_text"
        const val ACTION_CUT_PAPER = "cut_paper"
        const val ACTION_FEED_PAPER = "feed_paper"
        const val ACTION_PRINT_QRCODE = "print_qrcode"
        
        private const val TIMEOUT_MS = 10000L // 10 second timeout
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        // Get printer instance with listener
        printer = Printer.getInstance(this, this)

        val action = intent.getStringExtra("action") ?: ACTION_PRINT_TEXT
        
        Log.d("PrinterActivity", "Action received: $action")
        Log.d("PrinterActivity", "All extras: ${intent.extras}")

        try {
            when (action) {
                ACTION_PRINT_TEXT -> handlePrintText()
                ACTION_CUT_PAPER -> handleCutPaper()
                ACTION_FEED_PAPER -> handleFeedPaper()
                ACTION_PRINT_QRCODE -> handlePrintQRCode()
                else -> returnError("Unknown action: $action")
            }
            
            // Set a timeout to prevent the activity from hanging
            handler.postDelayed({
                if (isPrinting) {
                    Log.e("PrinterActivity", "Operation timeout")
                    returnError("Operation timeout")
                }
            }, TIMEOUT_MS)
            
        } catch (e: Exception) {
            Log.e("PrinterActivity", "Error executing action: $action", e)
            returnError(e.message ?: "Unknown error")
        }
    }

    private fun handlePrintText() {
        val text = intent.getStringExtra("text")
        val alignment = intent.getStringExtra("alignment") ?: "LEFT"
        val fontSize = intent.getIntExtra("fontSize", 24)
        val isBold = intent.getBooleanExtra("isBold", false)

        Log.d("PrinterActivity", "handlePrintText - text: $text, alignment: $alignment, fontSize: $fontSize, isBold: $isBold")

        if (text == null) {
            Log.e("PrinterActivity", "No text provided")
            returnError("No text provided")
            return
        }

        isPrinting = true

        // Create text format
        val textFormat = TextFormat()
        textFormat.fontSize = fontSize
        textFormat.setBold(isBold)
        
        // Set alignment
        textFormat.alignment = when (alignment.uppercase()) {
            "CENTER" -> Alignment.CENTER
            "RIGHT" -> Alignment.RIGHT
            else -> Alignment.LEFT
        }

        Log.d("PrinterActivity", "Printing text with format...")

        printer.printText(textFormat, text)
        
        printer.scrollPaper(3)

        Log.d("PrinterActivity", "Print text command sent successfully")
    }

    private fun handleCutPaper() {
        Log.d("PrinterActivity", "handleCutPaper")
        
        isPrinting = true
        
        // Feed some lines before cutting to ensure clean cut
        printer.scrollPaper(50)
        
        // Cut paper
        printer.cutPaper(CutType.PAPER_FULL_CUT)

        Log.d("PrinterActivity", "Cut paper command executed")
    }

    private fun handleFeedPaper() {
        val lines = intent.getIntExtra("lines", 10)
        
        Log.d("PrinterActivity", "handleFeedPaper - lines: $lines")
        
        isPrinting = true
        
        // Scroll paper to feed empty lines
        printer.scrollPaper(lines)
        
        Log.d("PrinterActivity", "Feed paper: $lines lines")
    }

    private fun handlePrintQRCode() {
        val qrCodeData = intent.getStringExtra("qrCodeData")
        val size = intent.getStringExtra("size") ?: "HALF"
        
        Log.d("PrinterActivity", "handlePrintQRCode - qrCodeData: $qrCodeData, size: $size")
        
        if (qrCodeData == null) {
            Log.e("PrinterActivity", "No QR code data provided")
            returnError("No QR code data provided")
            return
        }

        isPrinting = true

        // Create barcode format for QR Code
        val barcodeSize = when (size.uppercase()) {
            "FULL" -> BarcodeFormat.Size.FULL_PAPER
            "HALF" -> BarcodeFormat.Size.HALF_PAPER
            else -> BarcodeFormat.Size.HALF_PAPER
        }
        
        val barcodeFormat = BarcodeFormat(BarcodeType.QR_CODE, barcodeSize)
        
        Log.d("PrinterActivity", "Printing QR code...")
        
        // Print QR Code
        printer.printBarcode(barcodeFormat, qrCodeData)
        
        // Feed some lines after QR code
        printer.scrollPaper(3)
        
        Log.d("PrinterActivity", "QR Code print command sent successfully")
    }

    // Printer.Listener implementation - called when print is successful
    override fun onPrinterSuccessful(printerRequestId: Int) {
        Log.d("PrinterActivity", "Print successful with requestId: $printerRequestId")
        
        handler.removeCallbacksAndMessages(null) // Remove timeout
        isPrinting = false
        printSuccess = true
        
        setResult(Activity.RESULT_OK)
        finish()
    }

    // Printer.Listener implementation - called when print error occurs
    override fun onPrinterError(printerError: PrinterError) {
        // Log.e("PrinterActivity", "Printer error: ${printerError.code} - ${printerError.message}")
        
        handler.removeCallbacksAndMessages(null) // Remove timeout
        isPrinting = false
        
        // returnError("Printer error: ${printerError.message}")
    }

    private fun returnError(error: String) {
        Log.e("PrinterActivity", "Returning error: $error")
        
        handler.removeCallbacksAndMessages(null) // Remove timeout
        isPrinting = false
        
        val resultIntent = Intent()
        resultIntent.putExtra("error", error)
        setResult(Activity.RESULT_CANCELED, resultIntent)
        finish()
    }

    override fun onDestroy() {
        super.onDestroy()
        handler.removeCallbacksAndMessages(null)
        Log.d("PrinterActivity", "Activity destroyed")
    }
}