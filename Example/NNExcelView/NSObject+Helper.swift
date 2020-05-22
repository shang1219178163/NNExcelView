
//
//  NSObject+Helper.swift
//  SwiftTemplet
//
//  Created by Bin Shang on 2019/9/12.
//  Copyright © 2019 BN. All rights reserved.
//

import UIKit


@objc public extension NSObject{


}

@objc extension UIImageView{
    
  

}

@objc public extension Bundle{
    /// 国际化语言适配
    static func localizedString(forKey key: String, comment: String = "", userDefaultsKey: String = "AppLanguage") -> String {
        let defaultValue = NSLocalizedString(key, comment: comment)
        guard let name = UserDefaults.standard.object(forKey: userDefaultsKey) as? String else { return defaultValue }
        guard let lprojBundlePath = Bundle.main.path(forResource: name, ofType: "lproj") else { return defaultValue }
        guard let lprojBundle = Bundle(path: lprojBundlePath) else { return defaultValue }
        let value = NSLocalizedString(key, bundle: lprojBundle, comment: comment)
//        let value = bundle!.localizedString(forKey: key, value: "", table: nil)
        return value;
    }
//    /// 国际化语言适配
//    static func localizedString(forKey key: String, comment: String = "") -> String {
//        let defaultValue = NSLocalizedString(key, comment: comment)
//        guard let name = UserDefaults.standard.object(forKey: "AppLanguage") as? String else { return defaultValue }
//        guard let lprojBundlePath = Bundle.main.path(forResource: name, ofType: "lproj") else { return defaultValue }
//        guard let lprojBundle = Bundle(path: lprojBundlePath) else { return defaultValue }
//        let value = NSLocalizedString(key, bundle: lprojBundle, comment: comment)
////        let value = bundle!.localizedString(forKey: key, value: "", table: nil)
//        return value;
//    }
    
}

@objc public extension UIApplication{

    
}

@objc public extension UIView{

    
}

@objc public extension UIBarButtonItem{
    

    
}
