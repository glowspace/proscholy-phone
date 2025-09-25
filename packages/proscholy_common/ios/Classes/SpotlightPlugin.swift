import Flutter
import UIKit
import CoreSpotlight
import MobileCoreServices

struct SpotlightItem: Codable {
    let identifier: String
    let title: String
    let description: String
}

class SpotlightPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel!
    private var initiallyOpenedItemIdentifier: String?

    private var dartReady = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "proscholyCommon/spotlight", binaryMessenger: registrar.messenger())
        let instance = SpotlightPlugin()

        instance.channel = channel

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getInitiallyOpenedItemIdentifier":
                let identifier = initiallyOpenedItemIdentifier
                initiallyOpenedItemIdentifier = nil
                dartReady = true

                result(identifier)
                break
            case "indexItems":
                let decoder = JSONDecoder()

                do {
                    if let arguments = call.arguments as? String {
                        let items = try decoder.decode([SpotlightItem].self, from: Data(arguments.utf8))
                        index(items: items)
                    }
                } catch { }

                result(nil)
                break
            case "deindexItems":
                if let identifiers = call.arguments as? [String] {
                    deindex(identifiers: identifiers)
                }

                result(nil)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    private func index(items: [SpotlightItem]) {
        var searchableItems = [CSSearchableItem]()

        for item in items {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = item.title
            attributeSet.displayName = item.title
            attributeSet.contentDescription = item.description

            let searchableItem = CSSearchableItem(uniqueIdentifier: item.identifier, domainIdentifier: Bundle.main.bundleIdentifier ?? "", attributeSet: attributeSet)
            searchableItem.expirationDate = Date.distantFuture

            searchableItems.append(searchableItem)
        }

        CSSearchableIndex.default().indexSearchableItems(searchableItems)
    }

    private func deindex(identifiers: [String]) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: identifiers)
    }

    // MARK: - Handle Spotlight activity

    public func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]) -> Void) -> Bool {
        if userActivity.activityType == CSSearchableItemActionType {
            userActivity.resignCurrent()
            userActivity.invalidate()

            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                if dartReady {
                    channel.invokeMethod("onOpenedItem", arguments: uniqueIdentifier)
                } else {
                    initiallyOpenedItemIdentifier = uniqueIdentifier
                }
            }
        }

        return true
    }
}
