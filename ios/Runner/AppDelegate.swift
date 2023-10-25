import UIKit
import Flutter
import CoreSpotlight

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController

    OpenedFileService.shared.register(with: controller.binaryMessenger)
    PresentationService.shared.register(with: controller.binaryMessenger)
    SpotlightService.shared.register(with: controller.binaryMessenger)

    if let url = launchOptions?[.url] as? URL {
      OpenedFileService.shared.initiallyOpenedFile(url: url)
    }


    if let userActivityDictionary = launchOptions?[.userActivityDictionary] as? [UIApplication.LaunchOptionsKey: Any]  {
        if let userActivity = userActivityDictionary[UIApplication.LaunchOptionsKey(rawValue: "UIApplicationLaunchOptionsUserActivityKey")] as? NSUserActivity, userActivity.activityType == CSSearchableItemActionType {
          if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
            SpotlightService.shared.initiallyOpenedItem(with: uniqueIdentifier)
          }
      }
    }

    GeneratedPluginRegistrant.register(with: self)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
    OpenedFileService.shared.openedFile(url: url)

    return true
  }

  override func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
    if userActivity.activityType == CSSearchableItemActionType {
      if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
          SpotlightService.shared.openItem(with: uniqueIdentifier)
        }
    }

    return true
  }
}
