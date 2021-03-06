//
//  UIColor+Hex.swift
//  MaterialUI
//
//  Created by etudiant-06 on 24/03/2017.
//  Copyright © 2017 Mehdi Chennoufi. All rights reserved.
//

import Foundation
import UIKit

/** Extends UIColor to initialize UIColor using hex values, f.e. UIColor(hex: 0x8046A2) */
extension UIColor {
    convenience init(hex: Int, alpha: CGFloat) {
        let r = CGFloat((hex & 0xFF0000) >> 16)/255
        let g = CGFloat((hex & 0xFF00) >> 8)/255
        let b = CGFloat(hex & 0xFF)/255
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex:hex, alpha:1.0)
    }
}
