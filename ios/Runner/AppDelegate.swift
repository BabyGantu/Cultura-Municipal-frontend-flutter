import UIKit
import Flutter
import GoogleMaps
import Firebase

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     GMSServices.provideAPIKey("AIzaSyAObzTdfTWmSaUXydH0iPPqOO6dJCsRGSI")
    GeneratedPluginRegistrant.register(with: self)
     if FirebaseApp.app() == nil{
          FirebaseApp.configure()
      }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
