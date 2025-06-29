//
//  ViewController.swift
//  Appguard-Sample
//
//  Created by HyupM1 on 2022/12/01.
//

import UIKit
import AppGuard


class ViewController: UIViewController {

    @IBOutlet weak var isDebugModeLabel: UILabel!
    @IBOutlet weak var sdkVersionLabel: UILabel!
    @IBOutlet weak var appKeyLabel: UILabel!
    @IBOutlet weak var iOSVersionLabel: UILabel!
    @IBOutlet weak var sdkClassLabel: UILabel!
    @IBOutlet weak var userIdLabel: UILabel!
    @IBOutlet weak var deviceUUIDLabel: UILabel!
    @IBOutlet weak var appVersionLabel: UILabel!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var callbackLogTextView: UITextView!
   
    @IBOutlet weak var snapshotProtectionSwitch: UISwitch!
    @IBOutlet weak var contentProtectionSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        // Do any additional setup after loading the view.
        let appKey: String = "bMICt5To9z2xHbgA"
        let userName: String = "DEV"
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(callbackListener),
                                               name: NSNotification.Name(rawValue: "AGCallback"),
                                               object: nil)
        
        //Diresu.s("WVMxwI8lOBIBPVp1", "DEV", Bundle.appName(), Bundle.appVersion())
        //Diresu.o(self.method(for: #selector(result(_:))), true)

        AppGuardCore.doAppGuard(appKey, userName, Bundle.appName(), Bundle.appVersion())
        AppGuardCore.setCallback(self.method(for: #selector(result(_:))), true)
        self.contentProtectionSwitch.setOn(false, animated: false)
        self.snapshotProtectionSwitch.setOn(false, animated: false)
        self.appKeyLabel.text = String(format: "APPKEY: %@", appKey)
        self.userIdLabel.text = String(format: "UserName: %@", userName)
        self.iOSVersionLabel.text = String(format: "iOS Version: v%@", Bundle.systemVersion())
        self.sdkVersionLabel.text = String(format: "SDK Version: v%@", String(NHNAppGuardVersion))
        self.appNameLabel.text = String(format: "AppName: %@", Bundle.appName())
        self.appVersionLabel.text = String(format: "AppVersion: v%@", Bundle.appVersion())
        self.deviceUUIDLabel.text = String(format: "Device UUID: \n%@", Bundle.vendorUUID())
        self.isDebugModeLabel.text = String(Bundle.buildMode())
        self.callbackLogTextView.text = "AppGuard is started.\n"
        self.sdkClassLabel.text = String(format: "SDK Class Name: %@", Bundle.agClassName())
        
        
        
    }
    @objc func callbackListener(_ notification: Notification) {
        DispatchQueue.main.async {
            let log = notification.object as! String
            self.appendCallbackLogTextView(log)
        }
    }
    
    @objc func result(_ json: String) {
        print("appGuard detected callback: \(json)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "AGCallback"), object: json)
    }
    @IBAction func onSnapshotProtectionSwitch(_ sender: Any) {
        if(self.snapshotProtectionSwitch.isOn) {
            AppGuardCoreBlinder.protectSnapshot(true)
        } else {
            AppGuardCoreBlinder.protectSnapshot(false)
        }
    }
    
    @IBAction func onContentProtectionSwitch(_ sender: Any) {
        if(self.contentProtectionSwitch.isOn) {
            AppGuardCoreBlinder.protectContent(true)
        } else {
            AppGuardCoreBlinder.protectContent(false)
        }
    }
    func appendCallbackLogTextView(_ log: String) {
        self.callbackLogTextView.text = self.callbackLogTextView.text.appendingFormat("%@\n", log)
        self.callbackLogTextView.scrollRangeToVisible(NSMakeRange(self.callbackLogTextView.text.count, 0))
        
    }

}

extension Bundle {
    static func appVersion() -> String {
        guard let bundleDictionary = Bundle.main.infoDictionary,
              let version = bundleDictionary["CFBundleShortVersionString"] as? String
        else {
            return "x.y.z"
        }
        return version
    }
    
    static func appName() -> String {
        guard let bundleDictionary = Bundle.main.infoDictionary,
              let displayName = bundleDictionary["CFBundleName"] as? String
        else {
            return "Unknown"
        }
        return displayName
    }
    
    static func agClassName() -> String {
       // return NSStringFromClass(Diresu.self);
    return NSStringFromClass(AppGuardCore.self);
    }
    
    static func buildMode() -> String {
#if DEBUG
        return "DEBUG MODE BUILD"
#else
        return "RELEASE MODE BUILD"
#endif
    }
    
    static func systemVersion() -> String {
        return UIDevice.current.systemVersion
    }
    
    static func vendorUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
}
