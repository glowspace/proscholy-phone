package jozkar.mladez

import android.app.Presentation
import android.content.Context
import android.os.Bundle
import android.util.Log
import android.view.Display
import android.view.ViewGroup
import android.widget.FrameLayout
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngineCache

class PresentationDisplay(context: Context, display: Display): Presentation(context, display) {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val flContainer = FrameLayout(context)
        val params = FrameLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT
        )
        flContainer.layoutParams = params

        setContentView(flContainer)

        val flutterView = FlutterView(context)
        flContainer.addView(flutterView, params)

        val flutterEngine = FlutterEngineCache.getInstance().get("/")!!
        flutterView.attachToFlutterEngine(flutterEngine)
    }
}