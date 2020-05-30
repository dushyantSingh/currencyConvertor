//
//  MainViewModelCoordinator.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Foundation

class MainViewModelCoordinator {
    
}

extension MainViewModelCoordinator {
    func createStartUpViewModel() -> ConvertorViewModel {
        let currencyService = CurrencyService()
        let viewModel = ConvertorViewModel(currencyService: currencyService)
        return viewModel
    }
}
