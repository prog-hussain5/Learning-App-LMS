import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {
    
  private var overlayWindow: UIWindow?

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      // Initialize Firebase
      FirebaseApp.configure()
      
      GeneratedPluginRegistrant.register(with: self)

      // MethodChannel الربط مع Flutter
      if let controller = window?.rootViewController as? FlutterViewController {
        let channel = FlutterMethodChannel(name: "screen_guard", binaryMessenger: controller.binaryMessenger)
        channel.setMethodCallHandler { [weak self] (call, result) in
          switch call.method {
          case "start":
            self?.startProtection()
            result(true)
          case "stop":
            self?.stopProtection()
            result(true)
          default:
            result(FlutterMethodNotImplemented)
          }
        }
      }

      return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  private func startProtection() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenCaptureChanged),
      name: UIScreen.capturedDidChangeNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(screenshotTaken),
      name: UIApplication.userDidTakeScreenshotNotification,
      object: nil
    )
    updateOverlay()
  }

  private func stopProtection() {
    NotificationCenter.default.removeObserver(self)
    overlayWindow?.isHidden = true
    overlayWindow = nil
  }

  @objc private func screenCaptureChanged() {
    updateOverlay()
  }

  @objc private func screenshotTaken() {
    // يمكنك هنا عرض Alert أو Log
  }

  private func updateOverlay() {
    let isCaptured = UIScreen.main.isCaptured
    if isCaptured {
      showOverlay()
    } else {
      hideOverlay()
    }
  }

  private func showOverlay() {
    if overlayWindow == nil {
      overlayWindow = UIWindow(frame: UIScreen.main.bounds)
      overlayWindow?.windowLevel = .alert + 1
      let vc = UIViewController()
      vc.view.backgroundColor = UIColor.black
      let label = UILabel()
      label.text = "Screen recording is not allowed"
      label.textColor = .white
      label.textAlignment = .center
      label.translatesAutoresizingMaskIntoConstraints = false
      vc.view.addSubview(label)
      NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor)
      ])
      overlayWindow?.rootViewController = vc
    }
    overlayWindow?.isHidden = false
  }

  private func hideOverlay() {
    overlayWindow?.isHidden = true
  }
}
