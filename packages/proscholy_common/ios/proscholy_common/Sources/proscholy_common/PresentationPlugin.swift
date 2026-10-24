import UIKit
import Flutter

class PresentationPlugin: NSObject, FlutterPlugin, FlutterStreamHandler {
    private var channel: FlutterMethodChannel!

    private var externalWindow: UIWindow?

    private var dataSink: FlutterEventSink?
    private var pendingData: String?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "proscholyCommon/presentation", binaryMessenger: registrar.messenger())
        let instance = PresentationPlugin()

        instance.channel = channel

        registrar.addMethodCallDelegate(instance, channel: channel)

        let externalDisplayChannel = FlutterEventChannel(name: "proscholyCommon/presentation/externalDisplay", binaryMessenger: registrar.messenger())
        externalDisplayChannel.setStreamHandler(ExternalDisplayStreamHandler())

        NotificationCenter.default.addObserver(instance, selector: #selector(sceneDidDisconnect), name: UIScene.didDisconnectNotification, object: nil)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch (call.method) {
            case "startPresentation":
                self.startPresentation()

                result(nil)
                break
            case "stopPresentation":
                self.stopPresentation()

                result(nil)
                break
            case "isExternalScreenConnected":
                result(UIScreen.screens.count > 1)
                break
            case "transferData":
                if let data = call.arguments as? String {
                    self.transferData(data: data)
                }

                result(nil)
                break
            default:
                result(FlutterMethodNotImplemented)
                break
        }
    }

    private func startPresentation() {
        let scenes = UIApplication.shared.connectedScenes

        guard let windowScene = scenes.first { $0.session.role == .windowExternalDisplay } as? UIWindowScene else {
            print("No external window scene found")
            return
        }

        let externalWindow = UIWindow(windowScene: windowScene)

        let engine = FlutterEngine(name: "presentation_engine")
        engine.run(withEntrypoint: "mainPresentation", initialRoute: "/")

        let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)

        externalWindow.frame = windowScene.screen.bounds
        externalWindow.rootViewController = flutterViewController
        externalWindow.isHidden = false

        let eventChannel = FlutterEventChannel(name: "proscholyCommon/presentation/stream", binaryMessenger: flutterViewController.binaryMessenger)
        eventChannel.setStreamHandler(self)

        self.externalWindow = externalWindow
    }

    private func stopPresentation() {
        if let externalWindow = externalWindow {
            externalWindow.isHidden = true
            dataSink?(FlutterEndOfEventStream)
            dataSink = nil

            self.externalWindow = nil
        }
    }

    private func transferData(data: String) {
        if let dataSink = dataSink {
            dataSink(data)
        } else {
            pendingData = data
        }
    }

    // MARK: - UIScene observers

    @objc func sceneDidDisconnect(notification: Notification) {
        guard let scene = notification.object as? UIWindowScene, scene === externalWindow?.windowScene else { return }

        stopPresentation()

        channel.invokeMethod("onExternalDisplayDisconnected", arguments: nil)
    }

    // MARK: - FlutterStreamHandler

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.dataSink = eventSink

        if let data = pendingData {
            eventSink(data)
            pendingData = nil
        }

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        dataSink?(FlutterEndOfEventStream)
        dataSink = nil

        return nil
    }
}

// sends whether external display is connected, when it is listened to and whenever it connects or disconnects
class ExternalDisplayStreamHandler: NSObject, FlutterStreamHandler {
    private var eventSink: FlutterEventSink?

    public func onListen(withArguments arguments: Any?, eventSink: @escaping FlutterEventSink) -> FlutterError? {
        self.eventSink = eventSink

        NotificationCenter.default.addObserver(self, selector: #selector(sceneWillConnect), name: UIScene.willConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(sceneDidDisconnect), name: UIScene.didDisconnectNotification, object: nil)

        eventSink(UIScreen.screens.count > 1)

        return nil
    }

    public func onCancel(withArguments arguments: Any?) -> FlutterError? {
        NotificationCenter.default.removeObserver(self)

        eventSink = nil

        return nil
    }

    @objc func sceneWillConnect(notification: Notification) {
        guard let scene = notification.object as? UIWindowScene, scene.session.role == .windowExternalDisplay else { return }

        eventSink?(true)
    }

    @objc func sceneDidDisconnect(notification: Notification) {
        guard let scene = notification.object as? UIWindowScene, scene.session.role == .windowExternalDisplay else { return }

        eventSink?(false)
    }
}
