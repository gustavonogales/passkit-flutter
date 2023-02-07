import UIKit
import Flutter
import PassKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let channelName = "br.com.kamino/passkit";
      let passKitChannel = FlutterMethodChannel(name: channelName, binaryMessenger: controller.binaryMessenger)
      
      passKitChannel.setMethodCallHandler({(call: FlutterMethodCall, result: FlutterResult) -> Void in
          guard call.method == "canAddPasses" else {
              result(FlutterMethodNotImplemented)
              return
          }
          let isAvailable = PKAddPassesViewController.canAddPasses();
          result(isAvailable)
      })
      
      GeneratedPluginRegistrant.register(with: self)
      
        weak var registrar = self.registrar(forPlugin: "add-button")
        let factory = AddButtonFactory(messenger: registrar!.messenger(), channel: passKitChannel)
        self.registrar(forPlugin: "<add-button>")!.register(factory, withId: "<passkit-wallet-button>")
          
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

