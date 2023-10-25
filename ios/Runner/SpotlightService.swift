import Flutter
import UIKit
import CoreSpotlight
import MobileCoreServices

struct SpotlightItem: Codable {
    let identifier: String
    let title: String
    let description: String
}

class SpotlightService: NSObject {
    static let shared = SpotlightService()

    override private init() { }

    private var channel: FlutterMethodChannel!
    private var initiallyOpenedItemIdentifier: String?

    func register(with binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "spotlight", binaryMessenger: binaryMessenger)

        channel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "getInitiallyOpenedItemIdentifier":
                    let identifier = self?.initiallyOpenedItemIdentifier
                    self?.initiallyOpenedItemIdentifier = nil

                    result(identifier)
                    break
                case "indexItems":
                    let decoder = JSONDecoder()

                    do {
                        if let arguments = call.arguments as? String {
                            let items = try decoder.decode([SpotlightItem].self, from: Data(arguments.utf8))
                            self?.index(items: items)
                        }
                    } catch { }

                    result(nil)
                    break
                case "deindexItems":
                    if let identifiers = call.arguments as? [String] {
                        self?.deindex(identifiers: identifiers)
                    }

                    result(nil)
                    break
                default:
                    result(FlutterMethodNotImplemented)
                    break
            }
        })
    }

    func initiallyOpenedItem(with identifier: String) {
        initiallyOpenedItemIdentifier = identifier
    }

    func openItem(with identifier: String) {
        channel.invokeMethod("onOpenedItem", arguments: identifier)
    }

    private func index(items: [SpotlightItem]) {
        var searchableItems = [CSSearchableItem]()

        for item in items {
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
            attributeSet.title = item.title
            attributeSet.displayName = item.title
            attributeSet.contentDescription = item.description

            let searchableItem = CSSearchableItem(uniqueIdentifier: item.identifier, domainIdentifier: "cz.proscholy", attributeSet: attributeSet)
            searchableItem.expirationDate = Date.distantFuture

            searchableItems.append(searchableItem)
        }

        CSSearchableIndex.default().indexSearchableItems(searchableItems)
    }

    private func deindex(identifiers: [String]) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: identifiers)
    }
}
