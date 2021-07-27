//
//  UIApplication+Extension.swift
//  FindYourPet
//
//  Created by mind-0023 on 22/07/21.
//

import UIKit

extension UIApplication {
    static var statusBarHeight: CGFloat {
        if #available(iOS 13.0, *) {
            let window = shared.windows.filter { $0.isKeyWindow }.first
            return window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
        }
        else {
            return shared.statusBarFrame.height
        }
    }
}
