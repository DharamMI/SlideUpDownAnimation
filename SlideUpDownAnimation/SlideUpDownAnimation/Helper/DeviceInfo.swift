//
//  DeviceInfo.swift
//  FindYourPet
//
//  Created by mind-0023 on 22/07/21.
//

import UIKit

struct Device {
    static var statusbarHeight = UIApplication.statusBarHeight
    static let viewHeight = Device.height - (Device.top_padding + Device.bottom_padding)
    static let width = UIScreen.main.bounds.size.width
    static let height = UIScreen.main.bounds.size.height
    static let max_length = max(Device.width, Device.height)
    static let min_length = min(Device.width, Device.height)
    static let top_padding = UIWindow.key?.safeAreaInsets.top ?? 0.0
    static let bottom_padding = UIWindow.key?.safeAreaInsets.bottom ?? 0.0
}
