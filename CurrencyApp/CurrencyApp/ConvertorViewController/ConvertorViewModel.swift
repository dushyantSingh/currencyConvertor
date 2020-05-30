//
//  ConvertorViewModel.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
import RxCocoa

enum ConvertViewModelEvents {
    case showConvertAlert
}
class ConvertorViewModel {
    let title = "Convert"
    let convertButtonClicked = PublishSubject<Void>()
    
    let events = PublishSubject<ConvertViewModelEvents>()
    private let disposeBag = DisposeBag()
   
    init() {
        setupEvents()
    }
}

extension ConvertorViewModel {
    private func setupEvents() {
        convertButtonClicked.asObservable()
            .map{.showConvertAlert}
            .bind(to: events)
            .disposed(by: disposeBag)
    }
}
