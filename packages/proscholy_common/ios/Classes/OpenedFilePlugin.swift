import Flutter
import UIKit

class OpenedFilePlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel!
    private var initiallyOpenedFile: String?

    private var dartReady = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "proscholyCommon/openedFile", binaryMessenger: registrar.messenger())
        let instance = OpenedFilePlugin()

        instance.channel = channel

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addApplicationDelegate(instance)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getInitiallyOpenedFile":
                let file = initiallyOpenedFile
                initiallyOpenedFile = nil
                dartReady = true

                result(file)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    // MARK: - Handle opened file activity

    public func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        _ = url.startAccessingSecurityScopedResource()

        if dartReady {
            channel.invokeMethod("onOpenedFile", arguments: try? String(contentsOf: url))
        } else {
            initiallyOpenedFile = try? String(contentsOf: url)
        }

        url.stopAccessingSecurityScopedResource()

        return true
    }
}
