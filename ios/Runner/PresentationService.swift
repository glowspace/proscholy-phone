import UIKit
import Flutter

class PresentationService: NSObject, FlutterStreamHandler {
    static let shared = PresentationService()

    override private init() { }

    private var externalScreen: UIScreen?
    private var externalWindow: UIWindow?

    private var dataSink: FlutterEventSink?
    private var pendingData: String?

    func register(with binaryMessenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "presentation", binaryMessenger: binaryMessenger)

        channel.setMethodCallHandler({
            [weak self](call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch (call.method) {
                case "startPresentation":
                    self?.startPresentation()

                    result(nil)
                    break
                case "stopPresentation":
                    self?.stopPresentation()

                    result(nil)
                    break
                case "isExternalScreenConnected":
                    result(UIScreen.screens.count > 1)

                    break
                case "transferData":
                    if let data = call.arguments as? String {
                        self?.transferData(data: data)
                    }

                    result(nil)
                    break
                default:
                    result(FlutterMethodNotImplemented)
                    break
                }
        })

        NotificationCenter.default.addObserver(self, selector: #selector(screenDidConnect), name: UIScreen.didConnectNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(screenDidDisconnect), name: UIScreen.didDisconnectNotification, object: nil)
    }

    private func startPresentation() {
        if let externalScreen = externalScreen {
            let externalWindow = UIWindow(frame: externalScreen.bounds)
            externalWindow.screen = externalScreen
            externalWindow.isHidden = false

            let engine = FlutterEngine()
            engine.run(withEntrypoint: "mainPresentation", initialRoute: "/")

            let flutterViewController = FlutterViewController(engine: engine, nibName: nil, bundle: nil)
            flutterViewController.view.frame = externalWindow.screen.bounds

            externalWindow.rootViewController = flutterViewController

            let eventChannel = FlutterEventChannel(name: "presentation/stream", binaryMessenger: flutterViewController.binaryMessenger)
            eventChannel.setStreamHandler(self)

            self.externalWindow = externalWindow
        }
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

    // MARK: - UIScreen observers

    @objc func screenDidConnect(notification: Notification) {
        guard let externalScreen = notification.object as? UIScreen else { return }

        self.externalScreen = externalScreen
    }

    @objc func screenDidDisconnect(notification: Notification) {
        guard let externalScreen = notification.object as? UIScreen, externalScreen == self.externalScreen else { return }

        self.externalScreen = nil
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
