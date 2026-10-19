package cz.glowspace.proscholy_common

import android.app.Activity
import android.content.ActivityNotFoundException
import android.net.Uri

import androidx.browser.customtabs.CustomTabsClient
import androidx.browser.customtabs.CustomTabsIntent

import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

object BrowserService {
    var activity: Activity? = null

    fun register(binaryMessenger: BinaryMessenger) {
        val channel = MethodChannel(binaryMessenger, "proscholyCommon/browser")
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "openInCustomTab" -> result.success(openInCustomTab(Uri.parse(call.arguments as String)))
                else -> result.notImplemented()
            }
        }
    }

    // links to the website resolve to the app, which handles them, unless the browser is set explicitly
    private fun openInCustomTab(uri: Uri): Boolean {
        val activity = activity ?: return false
        val browser = CustomTabsClient.getPackageName(activity, null) ?: return false

        val customTabsIntent = CustomTabsIntent.Builder().setShowTitle(true).build()
        customTabsIntent.intent.setPackage(browser)

        return try {
            customTabsIntent.launchUrl(activity, uri)
            true
        } catch (e: ActivityNotFoundException) {
            false
        }
    }
}
