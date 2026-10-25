import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
    func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
        GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    }
}

class SceneDelegate: FlutterSceneDelegate {
    // window controls of iPadOS get a thin strip above the app, which is part of the safe area, so they don't cover app bars
    @available(iOS 26.0, *)
    override func preferredWindowingControlStyle(for windowScene: UIWindowScene) -> UIWindowScene.WindowingControlStyle {
        .minimal
    }
}
