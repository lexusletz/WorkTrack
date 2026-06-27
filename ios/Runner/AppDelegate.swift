import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
      
    let installationChannel = FlutterMethodChannel(
        name: "io.github.lexusletz.worktrack/installation",
        binaryMessenger: engineBridge.applicationRegistrar.messenger()
    )
      
      installationChannel.setMethodCallHandler({
          (call: FlutterMethodCall, result: FlutterResult) -> Void in
          if call.method == "getBinaryCreationDate" {
              if let bundleUrl = Bundle.main.executableURL {
                  do {
                      let attributes = try FileManager.default.attributesOfItem(atPath: bundleUrl.path)
                      if let creationDate = attributes[.creationDate] as? Date {
                          print(creationDate)
                          let timestamp = Int(creationDate.timeIntervalSince1970)
                          print(timestamp)
                          result(timestamp)
                          return
                      }
                  } catch {
                      result(FlutterError(code: "ERROR_FILE", message: "Couldn't get file attributes", details: nil))
                      return
                  }
              }
              result(FlutterError(code: "ERROR_PATH", message: "Couldn't get bundle URL", details: nil))
          } else {
              result(FlutterMethodNotImplemented)
          }
      })
  }
}
