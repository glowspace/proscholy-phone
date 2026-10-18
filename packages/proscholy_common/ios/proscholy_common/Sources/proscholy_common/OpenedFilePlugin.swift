import Flutter
import UIKit

class OpenedFilePlugin: NSObject, FlutterPlugin, FlutterSceneLifeCycleDelegate {
    private var channel: FlutterMethodChannel!
    private var initiallyOpenedFile: String?

    private var dartReady = false

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "proscholyCommon/openedFile", binaryMessenger: registrar.messenger())
        let instance = OpenedFilePlugin()

        instance.channel = channel

        registrar.addMethodCallDelegate(instance, channel: channel)
        registrar.addSceneDelegate(instance)
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

    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) -> Bool {
        guard let url = URLContexts.first?.url else { return false }

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
