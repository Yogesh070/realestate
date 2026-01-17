import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // Read API key from dart-define (passed via --dart-define)
    let dartDefineKey = Bundle.main.object(forInfoDictionaryKey: "GOOGLE_MAPS_API_KEY") as? String ?? ""
    if !dartDefineKey.isEmpty {
      GMSServices.provideAPIKey(dartDefineKey)
    } else {
      print("Warning: GOOGLE_MAPS_API_KEY not found in dart-define")
    }
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
