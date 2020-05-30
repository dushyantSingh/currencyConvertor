//
//  ConvertorViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class ConvertorViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = ConvertorViewModel
       var viewModel: ConvertorViewModel!
    
    override func viewDidLoad() {
        setupUI()
    }
}
extension ConvertorViewController {
    private func setupUI() {
        self.title = viewModel.title
    }
}
