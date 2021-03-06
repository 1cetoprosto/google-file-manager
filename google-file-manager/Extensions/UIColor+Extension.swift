//
//  UIColor+Extension.swift
//  google-file-manager
//
//  Created by Леонід Квіт on 13.06.2022.
//

import UIKit

extension UIColor {

    struct Main {
        static var text: UIColor { HEX.h05445E }
        static var background: UIColor { HEX.hD4F1F4 }
    }

    struct Button {
        static var title: UIColor { HEX.h007aff }
        static var border: UIColor { HEX.h007aff }
    }


    struct TableView {
        static var cellBackground: UIColor { HEX.hD4F1F4 }
        static var cellLabel: UIColor { HEX.h05445E }
    }

    struct NavBar {
        static var background: UIColor { HEX.h05445E }
        static var text: UIColor { HEX.h75E6DA }
    }

    fileprivate struct HEX {
        // main colors
        static let h05445E = UIColor(hex: 0x05445E)
        static let h007aff = UIColor(hex: 0x007aff)
        static let h75E6DA = UIColor(hex: 0x75E6DA)
        static let hD4F1F4 = UIColor(hex: 0xD4F1F4)
    }

}

extension UIColor {
    convenience init(hex: Int) {
        let components = (
            R: CGFloat((hex >> 16) & 0xff) / 255,
            G: CGFloat((hex >> 08) & 0xff) / 255,
            B: CGFloat((hex >> 00) & 0xff) / 255
        )
        self.init(red: components.R, green: components.G, blue: components.B, alpha: 1)
    }
}
