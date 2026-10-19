package cz.glowspace.proscholy_common

import android.app.Activity
import android.content.ContentResolver
import android.content.Intent
import android.net.Uri
import android.os.Handler
import android.os.Looper

import java.io.ByteArrayOutputStream

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object OpenedFileService {
    // playlists are small, bigger files are not read whole, so they can't run out of memory
    private const val MAX_FILE_SIZE = 5 * 1024 * 1024

    private lateinit var channel: MethodChannel
    private var initiallyOpenedFile: String? = null

    private var dartReady = false

    private val mainHandler = Handler(Looper.getMainLooper())

    var activity: Activity? = null

    fun register(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, "proscholyCommon/openedFile")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "getInitiallyOpenedFile" -> {
                    val file = initiallyOpenedFile
                    initiallyOpenedFile = null
                    dartReady = true

                    result.success(file)
                }
                else -> result.notImplemented()
            }
        }
    }

    fun handleIntent(intent: Intent) {
        val uri: Uri = intent.data ?: return

        // links to websites are handled by Flutter
        if (uri.scheme != ContentResolver.SCHEME_CONTENT && uri.scheme != ContentResolver.SCHEME_FILE) return

        val contentResolver = activity?.contentResolver ?: return

        // reading can be slow, e.g. for files in cloud storage
        Thread {
            val content = readFile(contentResolver, uri)

            mainHandler.post {
                if (dartReady) {
                    channel.invokeMethod("onOpenedFile", content)
                } else {
                    initiallyOpenedFile = content
                }
            }
        }.start()
    }

    // returns empty text for files that are too big, so they are shown as invalid playlist
    private fun readFile(contentResolver: ContentResolver, uri: Uri): String? {
        return try {
            contentResolver.openInputStream(uri)?.use { inputStream ->
                val content = ByteArrayOutputStream()
                val buffer = ByteArray(8192)
                var read = inputStream.read(buffer)

                while (read != -1) {
                    content.write(buffer, 0, read)

                    if (content.size() > MAX_FILE_SIZE) return ""

                    read = inputStream.read(buffer)
                }

                String(content.toByteArray(), Charsets.UTF_8)
            }
        } catch (e: Exception) {
            null
        }
    }
}
