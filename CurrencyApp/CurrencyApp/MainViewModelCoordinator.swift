//
//  MainViewModelCoordinator.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift

class MainViewModelCoordinator {
     let navigationAction = PublishSubject<NavigationAction>()
     private let disposeBag = DisposeBag()
}

extension MainViewModelCoordinator {
    func createStartUpViewModel() -> ConvertorViewModel {
        let currencyService = CurrencyService()
        let transactionDb = TransactionDb.shared
        let viewModel = ConvertorViewModel(currencyService: currencyService,
                                           transactionDB: transactionDb)
        self.setup(convertorViewModel: viewModel)
            .bind(to: self.navigationAction)
            .disposed(by: disposeBag)
        
        return viewModel
    }
    
    private func setup(convertorViewModel: ConvertorViewModel) -> Observable<NavigationAction> {
        return convertorViewModel.events
            .flatMap { event -> Observable<NavigationAction> in
                switch event {
                case .showTransactionView:
                    let stub = TransactionStub.transactions
                    let viewModel = TransactionViewModel(transactions: stub)
                    return Observable.just(.push(viewModel: viewModel,
                                                    animated: true))
                default: return Observable.empty()
                }
        }
    }
}
