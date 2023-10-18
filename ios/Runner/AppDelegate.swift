import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    OpenedFileService.shared.register(with: controller.binaryMessenger)
    PresentationService.shared.register(with: controller.binaryMessenger)

    if let url = launchOptions?[UIApplication.LaunchOptionsKey.url] as? URL {
      OpenedFileService.shared.initiallyOpenedFile(url: url)
    }

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    OpenedFileService.shared.openedFile(url: url)

    return true
  }
}
