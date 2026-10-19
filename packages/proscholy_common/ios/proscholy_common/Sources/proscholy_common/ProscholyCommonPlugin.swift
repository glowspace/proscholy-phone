import Flutter
import UIKit

public class ProscholyCommonPlugin: NSObject, FlutterPlugin {
    public static func register(with registrar: FlutterPluginRegistrar) {
        OpenedFilePlugin.register(with: registrar)
        PresentationPlugin.register(with: registrar)
        SpotlightPlugin.register(with: registrar)
    }
}
