//
//  TransactionViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = TransactionViewModel
    var viewModel: TransactionViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
    }
}
