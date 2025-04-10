import Cocoa
import FlutterMacOS

@main
class AppDelegate: FlutterAppDelegate {
    override func applicationDidFinishLaunching(_ notification: Notification) {
        if let flutterViewController = mainFlutterWindow?.contentViewController as? FlutterViewController {
            let registrar = flutterViewController.registrar(forPlugin: "UsbScannerPlugin")
            UsbScannerPlugin.register(with: registrar)
        }
        super.applicationDidFinishLaunching(notification)
    }
}