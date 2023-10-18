package jozkar.mladez

import java.io.BufferedReader
import java.io.InputStreamReader

import android.content.Context
import android.hardware.display.DisplayManager

import io.flutter.FlutterInjector
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.FlutterEngineCache
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

object PresentationService: EventChannel.StreamHandler  {
    private lateinit var context: Context

    private var presentationDisplay: PresentationDisplay? = null

    private var dataSink: EventChannel.EventSink? = null
    private var pendingData: String? = null

    fun register(context: Context, binaryMessenger: BinaryMessenger) {
        this.context = context

        val channel = MethodChannel(binaryMessenger, "presentation")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "startPresentation" -> {
                    startPresentation()

                    result.success(null)
                }
                "stopPresentation" -> {
                    stopPresentation()

                    result.success(null)
                }
                "isExternalScreenConnected" -> {
                    val displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
                    result.success(displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION).isNotEmpty())
                }
                "transferData" -> {
                    (call.arguments as? String)?.let { transferData(it) }

                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun startPresentation() {
        val displayManager = context.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        val presentationDisplays = displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)

        if (presentationDisplays.isNotEmpty()) {
            val flutterEngine = createFlutterEngine()

            val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "presentation/stream")
            eventChannel?.setStreamHandler(this)

            presentationDisplay = PresentationDisplay(context, presentationDisplays[0])
            presentationDisplay?.show()
        }
    }

    private fun stopPresentation() {
        presentationDisplay?.dismiss()
        presentationDisplay = null

        dataSink?.endOfStream()
        dataSink = null
    }

    private fun transferData(data: String) {
        if (dataSink == null)
            pendingData = data
        else
            dataSink?.success(data)
    }

    private fun createFlutterEngine(): FlutterEngine {
        if (FlutterEngineCache.getInstance().get("/") == null) {
            val flutterEngine = FlutterEngine(context)
            flutterEngine.getNavigationChannel().setInitialRoute("/")
            flutterEngine.getDartExecutor().executeDartEntrypoint(DartExecutor.DartEntrypoint(FlutterInjector.instance().flutterLoader().findAppBundlePath(), "mainPresentation"))
            flutterEngine.getLifecycleChannel().appIsResumed()

            FlutterEngineCache.getInstance().put("/", flutterEngine)
        }

        return FlutterEngineCache.getInstance().get("/")!!
    }

    // MARK: - FlutterStreamHandler

    override fun onListen(args: Any?, events: EventChannel.EventSink?) {
        dataSink = events

        if (pendingData != null) {
            dataSink?.success(pendingData!!)
            pendingData = null
        }
    }

    override fun onCancel(args: Any?) {
        dataSink?.endOfStream()
        dataSink = null
    }
}