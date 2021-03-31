//import Flutter
//import UIKit
//
//@UIApplicationMain
//@objc class AppDelegate: FlutterAppDelegate {
//    override func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]?
//    ) -> Bool {
//    var flutter_native_splash = 1
//    UIApplication.shared.isStatusBarHidden = false

//        GeneratedPluginRegistrant.register(with: self)
////        let viewController: MediaPickerViewController =
////            (UIApplication.shared.delegate?.window??.rootViewController)! as! MediaPickerViewController;
////        let channel = FlutterMethodChannel(name: "flutter_mapbox_navigation", binaryMessenger: registrar.messenger())
////        registrar.addMethodCallDelegate(instance, channel: channel)
////        eventChannel.setStreamHandler(instance)
//        weak var registrar = self.registrar(forPlugin: "plugin-name")
//        let factory = MediaPickerViewFactory(messenger: registrar!.messenger() )
//        self.registrar(forPlugin: "media")!.register(
//            factory,
//            withId: "mediaPickerView")
//        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
//    }
//}
//
//
//
import Flutter
import UIKit
import flutter_downloader
import Photos
@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
   // var selectedAssets = [TLPHAsset]()
   var tesst = "nhuw ri nef"
    var mediaChannel : FlutterMethodChannel!
    var imageStrBase64 = "=======init======== "
   // var listMediaDTO = [MediaDTO]()
    var listPath = [String]()

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    var flutter_native_splash = 1
    UIApplication.shared.isStatusBarHidden = false

    GeneratedPluginRegistrant.register(with: self)
    if #available(iOS 10.0, *) {
      UNUserNotificationCenter.current().delegate = self as UNUserNotificationCenterDelegate
    }

    let controller  = window?.rootViewController as! FlutterViewController
   
    weak var registrar = self.registrar(forPlugin: "plugin-name")

    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  override func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
              let deviceTokenString = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
              print("==== didRegisterForRemoteNotificationsWithDeviceToken ====")
              print(deviceTokenString)
              Messaging.messaging().apnsToken = deviceToken
      }
    
}

private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
