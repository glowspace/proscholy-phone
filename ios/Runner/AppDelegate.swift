import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  let advertiser = BLEAdvertiser()
  let discoverer = BLEDiscoverer()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    let controller: FlutterViewController = window?.rootViewController as! FlutterViewController

    let discoveredPublishersChannel = FlutterEventChannel(name: "platform_channel_events/discovered_publishers", binaryMessenger: controller.binaryMessenger)
    discoveredPublishersChannel.setStreamHandler(discoverer)
      
    let updatesChannel = FlutterEventChannel(name: "platform_channel_events/updates", binaryMessenger: controller.binaryMessenger)
      updatesChannel.setStreamHandler(discoverer.peripheralDelegate)

    let bleAdvertiserChannel = FlutterMethodChannel(name: "cz.proscholy.zpevnik/ble_advertise", binaryMessenger: controller.binaryMessenger)
    bleAdvertiserChannel.setMethodCallHandler(advertiser.handleMethodCall)

    let bleDiscovererChannel = FlutterMethodChannel(name: "cz.proscholy.zpevnik/ble_discover", binaryMessenger: controller.binaryMessenger)
    bleDiscovererChannel.setMethodCallHandler(discoverer.handleMethodCall)

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
