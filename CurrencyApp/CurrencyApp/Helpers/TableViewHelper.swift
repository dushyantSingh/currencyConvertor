//
//  TableViewCellHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

extension UITableView {
    public func registerCellClassForNib(cellClass: Swift.AnyClass) {
        let identifier = "\(cellClass)"
        self.register(UINib(nibName: identifier,
                            bundle: Bundle(for: cellClass)),
                      forCellReuseIdentifier: identifier)
    }
}
