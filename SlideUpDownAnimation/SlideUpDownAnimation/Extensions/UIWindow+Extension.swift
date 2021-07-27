//
//  UIWindow+Extension.swift
//  FindYourPet
//
//  Created by mind-0023 on 22/07/21.
//

import UIKit

extension UIWindow {
    static var key: UIWindow? {
        if #available(iOS 13, *) {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
        }
        else {
            return UIApplication.shared.keyWindow
        }
    }
}
