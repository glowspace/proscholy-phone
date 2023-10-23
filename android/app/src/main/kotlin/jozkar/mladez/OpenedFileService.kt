package jozkar.mladez

import java.io.BufferedReader
import java.io.InputStreamReader

import android.content.Intent
import android.content.Context

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object OpenedFileService {
    private lateinit var channel: MethodChannel
    private var initiallyOpenedFile: String? = null

    fun register(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, "opened_file")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitiallyOpenedFile" -> {
                    val file = initiallyOpenedFile
                    initiallyOpenedFile = null

                    result.success(file)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun initiallyOpenedFile(context: Context, intent: Intent) {
        readFile(context, intent)?.let {
            initiallyOpenedFile = it
        }
    }

    fun openedFile(context: Context, intent: Intent) {
        readFile(context, intent)?.let {
            channel.invokeMethod("onOpenedFile", it)
        }
    }

    private fun readFile(context: Context, intent: Intent): String? {
        val uri = intent.data

        if (uri != null) {
            val reader = BufferedReader(InputStreamReader(context.getContentResolver().openInputStream(uri)))
            val stringBuilder = StringBuilder()
            var line: String? = reader.readLine()

            while (line != null) {
                stringBuilder.append(line)
                line = reader.readLine()
            }

            reader.close()

            return stringBuilder.toString()
        }

        return null
    }
}