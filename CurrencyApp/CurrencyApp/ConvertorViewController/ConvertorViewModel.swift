//
//  ConvertorViewModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
import RxCocoa

class ConvertorViewModel {
    let title = "Convert"
    let convertButtonClicked = PublishSubject<Void>()
    
    private let disposeBag = DisposeBag()
   
    init() {
        setupEvents()
    }
}

extension ConvertorViewModel {
    private func setupEvents() {
        convertButtonClicked.asObservable()
            .subscribe(onNext: {_ in
                print("Convert button clicked")
            })
            .disposed(by: disposeBag)
    }
}
