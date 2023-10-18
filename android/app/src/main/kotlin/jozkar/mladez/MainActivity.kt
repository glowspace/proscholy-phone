package jozkar.mladez

import android.os.Bundle
import android.content.Intent

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity: FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        OpenedFileService.register(flutterEngine.dartExecutor.binaryMessenger)
        PresentationService.register(context, flutterEngine.dartExecutor.binaryMessenger)
    }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        OpenedFileService.initiallyOpenedFile(context, intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)

        OpenedFileService.openedFile(context, intent)
    }
}
