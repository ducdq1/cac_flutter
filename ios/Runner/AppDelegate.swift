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
//    mediaChannel = FlutterMethodChannel.init(name: "citizens.app/media_picker_ios",
//                                              binaryMessenger: controller.binaryMessenger)
   
    weak var registrar = self.registrar(forPlugin: "plugin-name")
//    let factory = MediaPickerViewFactory(messenger: registrar!.messenger() )
//          self.registrar(forPlugin: "media")!.register(
//              factory,
//              withId: "mediaWidgetIOS")
   
//    mediaChannel.setMethodCallHandler({
//      [weak self] (call: FlutterMethodCall, result: FlutterResult) -> Void in
//        if (call.method == "getChosenMedia")  {
//            guard  call.arguments != nil else {
//                return
//            }
//            self?.mediaPicker(result: result)
//            result("Tesst ++===========")
//        }
//        if (call.method == "nativeCallSomeFlutterMethod") {
//            result(self!.selectedAssets[0].originalFileName)
//        }
//    })
    FlutterDownloaderPlugin.setPluginRegistrantCallback(registerPlugins)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
}



private func registerPlugins(registry: FlutterPluginRegistry) {
    if (!registry.hasPlugin("FlutterDownloaderPlugin")) {
        FlutterDownloaderPlugin.register(with: registry.registrar(forPlugin: "FlutterDownloaderPlugin")!)
    }
}
