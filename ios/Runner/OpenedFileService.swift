import Flutter
import UIKit

class OpenedFileService: NSObject {
    static let shared = OpenedFileService()

    override private init() { }

    private var channel: FlutterMethodChannel!
    private var initiallyOpenedFile: String?

    func register(with binaryMessenger: FlutterBinaryMessenger) {
        channel = FlutterMethodChannel(name: "opened_file", binaryMessenger: binaryMessenger)

        channel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "getInitiallyOpenedFile":
                    let file = self?.initiallyOpenedFile
                    self?.initiallyOpenedFile = nil

                    result(file)
                    break
                default:
                    result(FlutterMethodNotImplemented)
                    break
            }
        })
    }

    func initiallyOpenedFile(url: URL) {
        do {
            initiallyOpenedFile = try String(contentsOf: url)
        } catch { }
    }

    func openedFile(url: URL) {
        do {
            channel.invokeMethod("onOpenedFile", arguments: try String(contentsOf: url))
        } catch { }
    }
}
