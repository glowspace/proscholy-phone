package cz.glowspace.proscholy_common

import android.app.Activity
import android.content.Intent
import android.net.Uri

import java.io.InputStream

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object OpenedFileService {
    private lateinit var channel: MethodChannel
    private var initiallyOpenedFile: String? = null

    private var dartReady = false

    var activity: Activity? = null

    fun register(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, "proscholyCommon/openedFile")
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

    fun handleIntent(intent: Intent) {
        val uri: Uri? = intent.data
        uri?.let {
            val content = readFileFromUri(it)
            if (dartReady) {
                channel.invokeMethod("onOpenedFile", content)
            } else {
                initiallyOpenedFile = content
            }
        }
    }

    private fun readFileFromUri(uri: Uri): String? {
        return try {
            val inputStream: InputStream? = activity?.contentResolver?.openInputStream(uri)
            inputStream?.bufferedReader()?.use { it.readText() }
        } catch (e: Exception) {
            null
        }
    }
}
