package cz.glowspace.proscholy_common

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding

class ProscholyCommonPlugin: FlutterPlugin, ActivityAware {
    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        OpenedFileService.register(binding.binaryMessenger)
        PresentationService.register(binding.binaryMessenger)
    }

    // ActivityAware callbacks
    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        OpenedFileService.activity = binding.activity
        PresentationService.context = binding.activity.applicationContext

        binding.addOnNewIntentListener { intent ->
            OpenedFileService.handleIntent(intent)
            false
        }

        // Handle launch intent if app started via file
        binding.activity?.intent?.let { OpenedFileService.handleIntent(it) }
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        OpenedFileService.activity = binding.activity
        PresentationService.context = binding.activity.applicationContext
    }

    override fun onDetachedFromActivity() {
        OpenedFileService.activity = null
        PresentationService.context = null
    }

	override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) { }
    override fun onDetachedFromActivityForConfigChanges() { }
}
