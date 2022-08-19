package jozkar.mladez

import androidx.annotation.NonNull

import android.content.Context
import android.bluetooth.BluetoothManager

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
  private val bluetoothManager: BluetoothManager by lazy {
    getSystemService(Context.BLUETOOTH_SERVICE) as BluetoothManager
  }

  private val advertiser: BLEAdvertiser by lazy {
    BLEAdvertiser(bluetoothManager, context)
  }

  private val discoverer: BLEDiscoverer by lazy {
    BLEDiscoverer(bluetoothManager, context)
  }

  override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
    super.configureFlutterEngine(flutterEngine)

    val discoveredPublishersChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "platform_channel_events/discovered_publishers")
    discoveredPublishersChannel.setStreamHandler(discoverer)

    val updatesChannel = EventChannel(flutterEngine.dartExecutor.binaryMessenger, "platform_channel_events/events")
    updatesChannel.setStreamHandler(discoverer.peripheralDelegate)

    val bleAdvertiserChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cz.proscholy.zpevnik/ble_advertise")
    bleAdvertiserChannel.setMethodCallHandler { call, result -> advertiser.handleMethodCall(call, result) }

    val bleDiscovererChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "cz.proscholy.zpevnik/ble_discover")
    bleDiscovererChannel.setMethodCallHandler { call, result -> discoverer.handleMethodCall(call, result) }
  }
}
