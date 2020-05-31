//
//  ViewHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

enum CornerRadius: CGFloat {
    case small = 2
    case large = 4
    case none = 0
}
extension UIView {
    func setCornerRadius(_ radius: CornerRadius) {
        self.layer.cornerRadius = radius.rawValue
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize(width: 1, height: 2)
    }
}
