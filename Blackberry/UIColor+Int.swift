//
//  UIColor+Int.swift
//  Blackberry
//
//  Created by 何鑫 on 16/4/23.
//  Copyright © 2016年 何鑫. All rights reserved.
//

import UIKit

extension UIColor {
    public convenience init(RGBInt: Int, alpha: CGFloat = 1) {
        let red = (RGBInt & 0xff0000) >> 16
        let green = (RGBInt & 0xff00) >> 8
        let blue = RGBInt & 0xff
        self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255 , blue: CGFloat(blue) / 255, alpha: alpha)
    }
}
