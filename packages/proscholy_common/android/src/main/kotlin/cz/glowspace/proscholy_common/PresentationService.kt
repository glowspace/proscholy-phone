package cz.glowspace.proscholy_common

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
    private lateinit var channel: MethodChannel

    private var presentationDisplay: PresentationDisplay? = null

    private var dataSink: EventChannel.EventSink? = null
    private var pendingData: String? = null

    private var externalDisplaySink: EventChannel.EventSink? = null

    private val displayListener = object : DisplayManager.DisplayListener {
        override fun onDisplayAdded(displayId: Int) {
            externalDisplaySink?.success(isExternalScreenConnected())
        }

        override fun onDisplayRemoved(displayId: Int) {
            externalDisplaySink?.success(isExternalScreenConnected())
        }

        override fun onDisplayChanged(displayId: Int) { }
    }

    var context: Context? = null

    fun register(binaryMessenger: BinaryMessenger) {
        channel = MethodChannel(binaryMessenger, "proscholyCommon/presentation")
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
                "isExternalScreenConnected" -> result.success(isExternalScreenConnected())
                "transferData" -> {
                    (call.arguments as? String)?.let { transferData(it) }

                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }

        // sends whether external display is connected, when it is listened to and whenever display is added or removed
        EventChannel(binaryMessenger, "proscholyCommon/presentation/externalDisplay").setStreamHandler(object : EventChannel.StreamHandler {
            override fun onListen(args: Any?, events: EventChannel.EventSink?) {
                externalDisplaySink = events

                (context!!.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager).registerDisplayListener(displayListener, null)

                events?.success(isExternalScreenConnected())
            }

            override fun onCancel(args: Any?) {
                (context?.getSystemService(Context.DISPLAY_SERVICE) as? DisplayManager)?.unregisterDisplayListener(displayListener)

                externalDisplaySink = null
            }
        })
    }

    private fun isExternalScreenConnected(): Boolean {
        val displayManager = context!!.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager

        return displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION).isNotEmpty()
    }

    private fun startPresentation() {
        val displayManager = context!!.getSystemService(Context.DISPLAY_SERVICE) as DisplayManager
        val presentationDisplays = displayManager.getDisplays(DisplayManager.DISPLAY_CATEGORY_PRESENTATION)

        if (presentationDisplays.isNotEmpty()) {
            val flutterEngine = createFlutterEngine()

            val eventChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "proscholyCommon/presentation/stream")
            eventChannel?.setStreamHandler(this)

            presentationDisplay = PresentationDisplay(context!!, presentationDisplays[0]) {
                stopPresentation()

                channel.invokeMethod("onExternalDisplayDisconnected", null)
            }
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
            // plugins of the app would register their channels again, so e.g. opened files would be sent to this engine
            val flutterEngine = FlutterEngine(context!!, null, false)
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
