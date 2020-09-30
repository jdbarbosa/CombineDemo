//
//  FontStyle.swift
//  CombineDemo
//
//  Created by João Barbosa on 28/09/2020.
//  Copyright © 2020 Glazed Solutions. All rights reserved.
//

import UIKit

enum FontStyle: String {
    case futuraBold = "Futura-Bold"
    case proximaNovaRegular = "ProximaNova-Regular"
}

enum FontSize: CGFloat {

    case heading = 25.0
    case title = 20.0
    case regular = 17.0
    case reading = 15.0
    case small = 12.5
    case tiny = 8.0

    var size: CGFloat { return rawValue }
}

extension UIFont {
    convenience init?(fontStyle: FontStyle, fontSize: FontSize) {
        self.init(name: fontStyle.rawValue, size: fontSize.size)
    }
}
