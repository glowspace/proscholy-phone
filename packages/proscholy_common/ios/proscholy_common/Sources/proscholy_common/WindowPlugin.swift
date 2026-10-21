import Flutter
import UIKit

// in windowed mode, iPadOS shows window controls in the top leading corner of the app, which isn't part of the safe area
class WindowPlugin: NSObject, FlutterPlugin {
    private var channel: FlutterMethodChannel!
    private var registrar: FlutterPluginRegistrar?
    private var windowControlsView: WindowControlsView?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "proscholyCommon/window", binaryMessenger: registrar.messenger())
        let instance = WindowPlugin()

        instance.channel = channel
        instance.registrar = registrar

        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
            case "getWindowControlsHeight":
                addWindowControlsView()

                result(Double(windowControlsView?.bounds.height ?? 0))
                break
            default:
                result(FlutterMethodNotImplemented)
        }
    }

    private func addWindowControlsView() {
        #if compiler(>=6.2)
        guard windowControlsView == nil, #available(iOS 26.0, *), let view = registrar?.viewController?.view else { return }

        let windowControlsView = WindowControlsView { [weak self] height in
            self?.channel.invokeMethod("windowControlsHeightChanged", arguments: Double(height))
        }

        view.addSubview(windowControlsView)

        // the system moves the top of the region that avoids window controls when the window changes
        NSLayoutConstraint.activate([
            windowControlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            windowControlsView.widthAnchor.constraint(equalToConstant: 0),
            windowControlsView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            windowControlsView.bottomAnchor.constraint(
                equalTo: view.layoutGuide(for: .safeArea(cornerAdaptation: .vertical)).topAnchor
            ),
        ])

        self.windowControlsView = windowControlsView
        #endif
    }
}

// hidden view as high as the space that window controls need below the safe area
private class WindowControlsView: UIView {
    private let onHeightChanged: (CGFloat) -> Void
    private var height: CGFloat = 0

    init(onHeightChanged: @escaping (CGFloat) -> Void) {
        self.onHeightChanged = onHeightChanged

        super.init(frame: .zero)

        isHidden = true
        isUserInteractionEnabled = false
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if bounds.height != height {
            height = bounds.height
            onHeightChanged(height)
        }
    }
}
