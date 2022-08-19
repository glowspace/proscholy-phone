import CoreBluetooth

let SONGS_SYNCING_SERVICE_UUID = CBUUID(string: "0155f6b5-b9c7-4dbc-8c6d-8449c42a7f02")
let SONGS_SYNCING_CHARACTERISTIC_UUID = CBUUID(string: "fdff7fc8-4e93-4772-ab38-ff8c98aba788")

let DISCOVERED_PERIPHERAL_VALIDITY_COUNTER = 1

class BLEAdvertiser: NSObject, CBPeripheralManagerDelegate {
  let manager: CBPeripheralManager

  lazy var characteristic: CBMutableCharacteristic = {
    CBMutableCharacteristic(type: SONGS_SYNCING_CHARACTERISTIC_UUID, properties: [.read, .notify], value: nil, permissions: .readable)
  }()

  lazy var service: CBMutableService = {
    let service = CBMutableService(type: SONGS_SYNCING_SERVICE_UUID, primary: true)

    service.characteristics = [characteristic]

    return service
  }()

  override init() {
    manager = CBPeripheralManager()

    super.init()

    manager.delegate = self
  }

  public func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "startAdvertising":
        if (manager.state != .poweredOn) {
          result(FlutterError(code: "ERROR_CODE", message: "Bluetooth is not turned on", details: nil))
        } else if let additional = call.arguments as? String {
          manager.startAdvertising([
            CBAdvertisementDataLocalNameKey: additional,
            CBAdvertisementDataServiceUUIDsKey: [service.uuid],
          ])

          result(nil)
        } else {
          result(FlutterError(code: "ERROR_CODE", message: "Missing additional data", details: nil))
        }

        return
      case "stopAdvertising":
        manager.stopAdvertising()

        result(nil)

        return
      case "updateValue":
        if let value = call.arguments as? String, let data = value.data(using: .utf8) {
          manager.stopAdvertising()
          manager.startAdvertising([
            CBAdvertisementDataLocalNameKey: value,
            CBAdvertisementDataServiceUUIDsKey: [service.uuid],
          ])

          manager.updateValue(data, for: characteristic, onSubscribedCentrals: nil)

          result(nil)
        } else {
          result(FlutterError(code: "ERROR_CODE", message: "Invalid value", details: nil))
        }

        return
      default:
        result(FlutterMethodNotImplemented)
        return
    }
  }

  // MARK: - CBPeripheralManagerDelegate

  // this function is not needed, but it is here to satisfy CBPeripheralManagerDelegate
  func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
    if (peripheral.state == .poweredOn) {
      manager.add(service)
    } else {
      manager.remove(service)
    }
  }
}

enum Message {
  /// discovered peripheral
  /// params:
  /// - peripheral uuid
  /// - data origin peripheral name
  /// - name contained in additional data
  case discoveredPublisher(UUID, String, String)
  /// data received from currently connected peripheral
  case data(String)
  /// uuid of connected peripheral
  case didConnect(UUID)
  /// uuid of disconnected peripheral
  case didDisconnect(UUID)
  /// discovered peripheral which got out of range or stopped advertising
  case lostPublisher(UUID)

  func encode() -> [String: Any] {
    switch (self) {
      case .discoveredPublisher(let uuid, let name, let additional):
        return ["msg_type": "discoveredPublisher", "uuid": uuid.uuidString, "name": name, "additional": additional]
      case .data(let data):
        return ["msg_type": "data", "data": data]
      case .didConnect(let name):
        return ["msg_type": "didConnect", "uuid": name.uuidString]
      case .didDisconnect(let name):
        return ["msg_type": "didDisconnect", "uuid": name.uuidString]
      case .lostPublisher(let uuid):
        return ["msg_type": "lostPublisher", "uuid": uuid.uuidString]
    }
  }
}

class BLEDiscoverer: NSObject, CBCentralManagerDelegate, FlutterStreamHandler {
  let manager: CBCentralManager
  let peripheralDelegate: PeripheralDelegate

  var discoveredPeripherals: [UUID: CBPeripheral]
  var discoveredPeripheralsCounter: [UUID: Int]

  var discoveredPublishersSink: FlutterEventSink?

  var connectedPeripheral: CBPeripheral?

  var timer: Timer!

  override init() {
    manager = CBCentralManager()
    peripheralDelegate = PeripheralDelegate(manager: manager)
    discoveredPeripherals = [:]
    discoveredPeripheralsCounter = [:]

    super.init()

    manager.delegate = self

    timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: checkDiscoveredPeripherals)
  }

  deinit {
    timer.invalidate()
  }

  public func handleMethodCall(call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
      case "connect":
        if let args = call.arguments as? String, let uuid = UUID(uuidString: args), let peripheral = discoveredPeripherals[uuid] {
          peripheral.delegate = peripheralDelegate
          manager.connect(peripheral)

          result(nil)
        } else {
          result(FlutterError(code: "ERROR_CODE", message: "Invalid peripheral identifier", details: nil))
        }

        return
      case "disconnect":
        if let peripheral = connectedPeripheral {
          manager.cancelPeripheralConnection(peripheral)
        }

        result(nil)
        return
      default:
        result(FlutterMethodNotImplemented)
        return
    }
  }

  // MARK: - FlutterStreamHandler

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    if (manager.state != .poweredOn) {
      return FlutterError(code: "ERROR_CODE", message: "Bluetooth is not turned on", details: nil)
    }

    discoveredPublishersSink = events

    manager.scanForPeripherals(withServices: [SONGS_SYNCING_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])

    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    manager.stopScan()

    discoveredPublishersSink?(FlutterEndOfEventStream)
    discoveredPublishersSink = nil

    return nil
  }

  // MARK: - CBCentralManagerDelegate

  // this function is not needed, but it is here to satisfy CBCentralManagerDelegate
  func centralManagerDidUpdateState(_ central: CBCentralManager) { }

  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if let name = peripheral.name, let additional = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
      if (discoveredPeripherals[peripheral.identifier] == nil) {
        send(.discoveredPublisher(peripheral.identifier, name, additional))
      }

      discoveredPeripherals[peripheral.identifier] = peripheral
      discoveredPeripheralsCounter[peripheral.identifier] = DISCOVERED_PERIPHERAL_VALIDITY_COUNTER
    }
  }

  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    send(.didConnect(peripheral.identifier))

    connectedPeripheral = peripheral

    peripheral.discoverServices([SONGS_SYNCING_SERVICE_UUID])
  }

  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    send(.didDisconnect(peripheral.identifier))
  }

  // MARK: - custom functions

  private func send(_ message: Message) {
    discoveredPublishersSink?(message.encode())
  }

  private func checkDiscoveredPeripherals(_ timer: Timer) {
    for (uuid, counter) in discoveredPeripheralsCounter {
      if (counter == 0) {
        discoveredPeripherals.removeValue(forKey: uuid)
        discoveredPeripheralsCounter.removeValue(forKey: uuid)
        send(.lostPublisher(uuid))
      } else {
        discoveredPeripheralsCounter[uuid] = counter - 1
      }
    }
  }
}

class PeripheralDelegate: NSObject, CBPeripheralDelegate, FlutterStreamHandler {
  let manager: CBCentralManager

  var updatesSink: FlutterEventSink?

  init(manager: CBCentralManager) {
    self.manager = manager

    super.init()
  }

  // MARK: - FlutterStreamHandler

  public func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
    if (manager.state != .poweredOn) {
      return FlutterError(code: "ERROR_CODE", message: "Bluetooth is not turned on", details: nil)
    }

    updatesSink = events

    manager.scanForPeripherals(withServices: [SONGS_SYNCING_SERVICE_UUID], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])

    return nil
  }

  public func onCancel(withArguments arguments: Any?) -> FlutterError? {
    manager.stopScan()

    updatesSink?(FlutterEndOfEventStream)
    updatesSink = nil

    return nil
  }

  // MARK: - CBPeripheralDelegate

  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    if let services = peripheral.services, let service = services.first {
      peripheral.discoverCharacteristics([SONGS_SYNCING_CHARACTERISTIC_UUID], for: service)
    } else {
      manager.cancelPeripheralConnection(peripheral)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    if let characteristics = service.characteristics, let characteristic = characteristics.first {
      peripheral.readValue(for: characteristic)
      peripheral.setNotifyValue(true, for: characteristic)
    } else {
      manager.cancelPeripheralConnection(peripheral)
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didModifyServices invalidatedServices: [CBService]) {
    for service in invalidatedServices {
      if (service.uuid == SONGS_SYNCING_SERVICE_UUID) {
        self.manager.cancelPeripheralConnection(peripheral)
      }
    }
  }

  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    if let value = characteristic.value, let data = String(data: value, encoding: .utf8) {
      send(.data(data))
    }
  }

  // MARK: - custom functions

  private func send(_ message: Message) {
    updatesSink?(message.encode())
  }
}
