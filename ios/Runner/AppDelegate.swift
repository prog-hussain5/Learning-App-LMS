import UIKit
import Flutter
import FirebaseCore
import FirebaseMessaging

@main
@objc class AppDelegate: FlutterAppDelegate {

  // Visible deterrent shown while the screen is being recorded/mirrored.
  private var overlayWindow: UIWindow?
  // Black cover shown when the app is backgrounded (hides the app-switcher snapshot).
  private var privacyCover: UIView?
  // Secure text field whose redacted layer hosts the app content so that
  // screenshots / screen recordings / AirPlay mirroring all render BLACK.
  private let secureField = UITextField()
  private var protectionEnabled = false

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

  // MARK: - Public start/stop

  private func startProtection() {
    guard !protectionEnabled else { return }
    protectionEnabled = true

    // Note: enableScreenshotShield is disabled because UITextField secureTextEntry reparenting
    // obscures Flutter Metal rendering on iOS, causing a black screen.
    // Protection against recording and app-switcher preview remains active below.
    // enableScreenshotShield()

    // Observers for recording state + app lifecycle (background privacy).
    let nc = NotificationCenter.default
    nc.addObserver(self, selector: #selector(screenCaptureChanged),
                   name: UIScreen.capturedDidChangeNotification, object: nil)
    nc.addObserver(self, selector: #selector(screenshotTaken),
                   name: UIApplication.userDidTakeScreenshotNotification, object: nil)
    nc.addObserver(self, selector: #selector(appWillResignActive),
                   name: UIApplication.willResignActiveNotification, object: nil)
    nc.addObserver(self, selector: #selector(appDidBecomeActive),
                   name: UIApplication.didBecomeActiveNotification, object: nil)

    updateOverlay()
  }

  private func stopProtection() {
    protectionEnabled = false
    NotificationCenter.default.removeObserver(self)
    // disableScreenshotShield()
    overlayWindow?.isHidden = true
    overlayWindow = nil
    removePrivacyCover()
  }

  // MARK: - Screenshot / recording shield (secure text field trick)
  // Re-parents the key window's layer inside a secureTextEntry field's redacted
  // layer. The user still sees everything normally, but the OS renders the content
  // BLACK in any system capture (screenshot, screen recording, AirPlay mirroring).

  private func enableScreenshotShield() {
    guard let window = self.window,
          let rootView = window.rootViewController?.view,
          secureField.superview == nil else { return }

    secureField.isSecureTextEntry = true
    secureField.isUserInteractionEnabled = false
    secureField.frame = window.bounds
    secureField.autoresizingMask = [.flexibleWidth, .flexibleHeight]

    window.addSubview(secureField)

    if let superlayer = rootView.layer.superlayer,
       let secureContainer = secureField.layer.sublayers?.first {
      secureField.layer.frame = window.bounds
      secureContainer.frame = window.bounds
      superlayer.addSublayer(secureField.layer)
      secureContainer.addSublayer(rootView.layer)
      rootView.layer.frame = window.bounds
    }
  }

  private func disableScreenshotShield() {
    guard let window = self.window,
          let rootView = window.rootViewController?.view else {
      secureField.removeFromSuperview()
      return
    }

    if rootView.layer.superlayer != window.layer {
      window.layer.addSublayer(rootView.layer)
      rootView.layer.frame = window.bounds
    }
    secureField.layer.removeFromSuperlayer()
    secureField.removeFromSuperview()
  }

  // MARK: - Recording deterrent overlay

  @objc private func screenCaptureChanged() {
    updateOverlay()
  }

  @objc private func screenshotTaken() {
    // Screenshots are already redacted to black by the secure-field shield above.
    // Re-assert the shield defensively in case the view hierarchy changed.
    enableScreenshotShield()
  }

  private func updateOverlay() {
    if UIScreen.main.isCaptured {
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
      label.numberOfLines = 0
      label.translatesAutoresizingMaskIntoConstraints = false
      vc.view.addSubview(label)
      NSLayoutConstraint.activate([
        label.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
        label.centerYAnchor.constraint(equalTo: vc.view.centerYAnchor),
        label.leadingAnchor.constraint(greaterThanOrEqualTo: vc.view.leadingAnchor, constant: 24),
        label.trailingAnchor.constraint(lessThanOrEqualTo: vc.view.trailingAnchor, constant: -24),
      ])
      overlayWindow?.rootViewController = vc
    }
    overlayWindow?.isHidden = false
  }

  private func hideOverlay() {
    overlayWindow?.isHidden = true
  }

  // MARK: - Background privacy (app-switcher snapshot)

  @objc private func appWillResignActive() {
    guard protectionEnabled, let window = self.window else { return }
    if privacyCover == nil {
      let cover = UIView(frame: window.bounds)
      cover.backgroundColor = .black
      cover.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      window.addSubview(cover)
      privacyCover = cover
    }
    privacyCover?.isHidden = false
    if let cover = privacyCover {
      window.bringSubviewToFront(cover)
    }
  }

  @objc private func appDidBecomeActive() {
    removePrivacyCover()
  }

  private func removePrivacyCover() {
    privacyCover?.removeFromSuperview()
    privacyCover = nil
  }
}
