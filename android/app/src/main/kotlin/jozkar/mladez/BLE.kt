package jozkar.mladez

import java.util.Timer;
import java.util.TimerTask;

import android.os.ParcelUuid

import android.content.Context

import android.bluetooth.BluetoothManager
import android.bluetooth.BluetoothAdapter
import android.bluetooth.BluetoothDevice
import android.bluetooth.BluetoothGatt
import android.bluetooth.BluetoothGattCallback
import android.bluetooth.BluetoothGattServer
import android.bluetooth.BluetoothGattServerCallback
import android.bluetooth.BluetoothGattService
import android.bluetooth.BluetoothGattCharacteristic
import android.bluetooth.BluetoothGattDescriptor
import android.bluetooth.BluetoothProfile

import android.bluetooth.le.AdvertiseData
import android.bluetooth.le.AdvertiseSettings
import android.bluetooth.le.AdvertiseCallback

import android.bluetooth.le.BluetoothLeScanner
import android.bluetooth.le.ScanFilter
import android.bluetooth.le.ScanCallback
import android.bluetooth.le.ScanResult
import android.bluetooth.le.ScanRecord

import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodCall

val SONGS_SYNCING_SERVICE_UUID = ParcelUuid.fromString("0155f6b5-b9c7-4dbc-8c6d-8449c42a7f02")
val SONGS_SYNCING_CHARACTERISTIC_UUID = ParcelUuid.fromString("fdff7fc8-4e93-4772-ab38-ff8c98aba788")

val DISCOVERED_PERIPHERAL_VALIDITY_COUNTER = 1

class BLEAdvertiser(bluetoothManager: BluetoothManager, context: Context) {
  private val bluetoothLeAdvertiser = bluetoothManager.adapter.bluetoothLeAdvertiser

  private val gattServer: BluetoothGattServer by lazy {
    bluetoothManager.openGattServer(context, bluetoothGattServerCallback)
  }

  private val characteristic: BluetoothGattCharacteristic by lazy {
    BluetoothGattCharacteristic(SONGS_SYNCING_CHARACTERISTIC_UUID.getUuid(), BluetoothGattCharacteristic.PROPERTY_NOTIFY, BluetoothGattCharacteristic.PERMISSION_READ)
  }

  private val service: BluetoothGattService by lazy {
    val service = BluetoothGattService(SONGS_SYNCING_SERVICE_UUID.getUuid(), BluetoothGattService.SERVICE_TYPE_PRIMARY)

    service.addCharacteristic(characteristic)

    service
  }

  public fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "startAdvertising" -> {
        val settings = AdvertiseSettings.Builder().build()
        val data = AdvertiseData.Builder().addServiceUuid(SONGS_SYNCING_SERVICE_UUID).build()

        gattServer.addService(service)

        bluetoothLeAdvertiser.startAdvertising(settings, data, leAdvertiseCallback)

        result.success(null)
        return
      }
      "stopAdvertising" -> {
        gattServer.removeService(service)

        bluetoothLeAdvertiser.stopAdvertising(leAdvertiseCallback)

        result.success(null)
        return
      }
      "updateValue" -> {
        characteristic.value = (call.arguments as String).toByteArray()

        for (device in gattServer.connectedDevices) {
          gattServer.notifyCharacteristicChanged(device, characteristic, false)
        }

        result.success(null)
        return
      }
      else -> {
        result.notImplemented()
        return
      }
    }
  }

  // MARK: - BLE handling

  private val leAdvertiseCallback: AdvertiseCallback = object : AdvertiseCallback() { }

  private val bluetoothGattServerCallback: BluetoothGattServerCallback = object : BluetoothGattServerCallback() {  }
}

sealed interface Message {
  // device address is used to identify the device instead of the UUID, uuid naming is used to keep it same as in swift version

  data class DiscoveredPublisher(val uuid: String, val name: String, val additional: String) : Message
  data class Data(val data: String) : Message
  data class DidConnect(val uuid: String) : Message
  data class DidDisconnect(val uuid: String) : Message
  data class LostPublisher(val uuid: String) : Message

  fun encode(): Map<String, Any> {
    return when (this) {
      is DiscoveredPublisher -> mapOf(
        "msg_type" to "discoveredPublisher",
        "uuid" to uuid.toString(),
        "name" to name,
        "additional" to additional
      )
      is Data -> mapOf(
        "msg_type" to "data",
        "data" to data
      )
      is DidConnect -> mapOf(
        "msg_type" to "didConnect",
        "uuid" to uuid.toString()
      )
      is DidDisconnect -> mapOf(
        "msg_type" to "didDisconnect",
        "uuid" to uuid.toString()
      )
      is LostPublisher -> mapOf(
        "msg_type" to "lostPublisher",
        "uuid" to uuid.toString()
      )
    }
  }
}

class BLEDiscoverer(bluetoothManager: BluetoothManager, context: Context): EventChannel.StreamHandler {
  private val bluetoothLeScanner = bluetoothManager.adapter.bluetoothLeScanner

  private val context = context

  public val peripheralDelegate = PeripheralDelegate()

  private var discoveredPeripherals = mutableMapOf<String, BluetoothDevice>()
  private var discoveredPeripheralsCounter = mutableMapOf<String, Int>()

  private var discoveredPublishersSink: EventChannel.EventSink? = null

  private var connectedPeripheral: BluetoothDevice? = null

  init {
    Timer().scheduleAtFixedRate(object : TimerTask() {
      override fun run() {
        checkDiscoveredPeripherals()
      }
    }, 0, 1000)
  }

  public fun handleMethodCall(call: MethodCall, result: MethodChannel.Result) {
    when (call.method) {
      "connect" -> {
        connectedPeripheral = discoveredPeripherals[call.arguments as String]
        connectedPeripheral?.connectGatt(context, true, peripheralDelegate.bluetoothGattCallback)

        result.success(null)
        return
      }
      "disconnect" -> {
        connectedPeripheral = null

        result.success(null)
        return
      }
      else -> {
        result.notImplemented()
        return
      }
    }
  }

  // MARK: - EventChannel.StreamHandler

  override fun onListen(args: Any?, events: EventChannel.EventSink?) {
    discoveredPublishersSink = events

    val scanFilters = ArrayList<ScanFilter>()
    scanFilters.add(ScanFilter.Builder().setServiceUuid(SONGS_SYNCING_SERVICE_UUID).build())

    bluetoothLeScanner.startScan(scanFilters, null, null)
  }

  override fun onCancel(args: Any?) {
    discoveredPublishersSink?.endOfStream()
    discoveredPublishersSink = null
  }

  // MARK: - BLE handling

  private val leScanCallback: ScanCallback = object : ScanCallback() {
    override fun onScanResult(callbackType: Int, result: ScanResult) {
      super.onScanResult(callbackType, result)

      // FIXME: compilation fails with 'unresolved reference', but should exist according to docs
      // result.scanRecord?.getAdvertisingData()

      if (!discoveredPeripherals.containsKey(result.device.address)) {
        send(Message.DiscoveredPublisher(result.device.getAddress(), result.scanRecord?.getDeviceName() ?: "", "6"))
      }

      discoveredPeripherals[result.device.getAddress()] = result.device
      discoveredPeripheralsCounter[result.device.getAddress()] = DISCOVERED_PERIPHERAL_VALIDITY_COUNTER
    }
  }

  // MARK: - Custom functions

  private fun send(message: Message) {
    discoveredPublishersSink?.success(message.encode())
  }


  private fun checkDiscoveredPeripherals() {
    discoveredPeripheralsCounter.forEach {
      if (it.value == 0) {
        send(Message.LostPublisher(it.key))
        discoveredPeripherals.remove(it.key)
        discoveredPeripheralsCounter.remove(it.key)
      } else {
        discoveredPeripheralsCounter[it.key] = it.value - 1
      }
    }
  }
}

class PeripheralDelegate: EventChannel.StreamHandler {
  private var updatesSink: EventChannel.EventSink? = null

  // MARK: - EventChannel.StreamHandler

  override fun onListen(args: Any?, events: EventChannel.EventSink?) {
    updatesSink = events
  }

  override fun onCancel(args: Any?) {
    updatesSink?.endOfStream()
    updatesSink = null
  }

  // MARK: - BLE handling

  public val bluetoothGattCallback: BluetoothGattCallback = object : BluetoothGattCallback() {
    override fun onConnectionStateChange(gatt: BluetoothGatt?, status: Int, newState: Int) {
      super.onConnectionStateChange(gatt, status, newState)

      if (newState == BluetoothProfile.STATE_CONNECTED) {
        send(Message.DidConnect(gatt?.device?.address ?: ""))
      } else if (newState == BluetoothProfile.STATE_DISCONNECTED) {
        send(Message.DidDisconnect(gatt?.device?.address ?: ""))
      }
    }

    override fun onServicesDiscovered(gatt: BluetoothGatt?, status: Int) {
      super.onServicesDiscovered(gatt, status)

      gatt?.services?.find { it.uuid == SONGS_SYNCING_SERVICE_UUID.getUuid() }
        ?.characteristics?.find { it.uuid == SONGS_SYNCING_CHARACTERISTIC_UUID.getUuid() }
        ?.let {
          gatt?.setCharacteristicNotification(it, true)
        }
    }

    override fun onCharacteristicChanged(gatt: BluetoothGatt?, characteristic: BluetoothGattCharacteristic?) {
      super.onCharacteristicChanged(gatt, characteristic)

      characteristic?.value?.let {
        send(Message.Data(String(it)))
      }
    }
  }

  // MARK: - Custom functions

  private fun send(message: Message) {
    updatesSink?.success(message.encode())
  }
}