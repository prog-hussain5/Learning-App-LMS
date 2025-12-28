import UIKit

class ScreenShieldView: UIView {
    private var shieldView: UIView?

    override init(frame: CGRect) {
        super.init(frame: frame)
        NotificationCenter.default.addObserver(self, selector: #selector(didTakeScreenshot), name: UIApplication.userDidTakeScreenshotNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didDetectScreenRecording), name: UIScreen.capturedDidChangeNotification, object: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func didTakeScreenshot() {
        showShield()
    }

    @objc private func didDetectScreenRecording() {
        if UIScreen.main.isCaptured {
            showShield()
        } else {
            hideShield()
        }
    }

    private func showShield() {
        if shieldView == nil {
            let shield = UIView(frame: self.bounds)
            shield.backgroundColor = .black
            shield.alpha = 1.0
            shield.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            self.addSubview(shield)
            shieldView = shield
        }
        shieldView?.isHidden = false
    }

    private func hideShield() {
        shieldView?.isHidden = true
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
