//
//  TransactionTableViewCell.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var transactionNumberLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var convertedCurrencyLabel: UILabel!
    @IBOutlet weak var conversionRateLabel: UILabel!
    @IBOutlet weak var contentBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentBackgroundView.setCornerRadius(.large)
    }
}
