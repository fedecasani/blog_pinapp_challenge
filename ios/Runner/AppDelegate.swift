import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let methodChannel = FlutterMethodChannel(name: "commentsChannel", binaryMessenger: controller.binaryMessenger)

    methodChannel.setMethodCallHandler { (call, result) in
        if call.method == "getComments" {
            guard let args = call.arguments as? [String: Any], let postId = args["postId"] as? Int else {
                result(FlutterError(code: "INVALID_ARGUMENTS", message: "postId no válido", details: nil))
                return
            }
            
            CommentService.fetchComments(for: postId) { comments, error in
                DispatchQueue.main.async {
                    if let error = error {
                        result(FlutterError(code: "API_ERROR", message: error.localizedDescription, details: nil))
                    } else {
                        result(comments)
                    }
                }
            }
        } else {
            result(FlutterMethodNotImplemented)
        }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
