//
//  ConvertorViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

class ConvertorViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = ConvertorViewModel
       var viewModel: ConvertorViewModel!
    
    @IBOutlet weak var convertButton: UIButton!
    private let disposeBag = DisposeBag()
    override func viewDidLoad() {
        setupUI()
    }
}
extension ConvertorViewController {
    private func setupUI() {
        self.title = viewModel.title
        convertButton.rx.tap
            .bind(to: viewModel.convertButtonClicked)
            .disposed(by: disposeBag)
    }
}
