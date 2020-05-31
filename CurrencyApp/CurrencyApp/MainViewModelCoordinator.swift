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
    let transactionDb: RealmDbType
    private let disposeBag = DisposeBag()
    
    init(transactionDb: RealmDbType = TransactionDb.shared) {
        self.transactionDb = transactionDb
    }
}

extension MainViewModelCoordinator {
    func createStartUpViewModel() -> ConvertorViewModel {
        let currencyService = CurrencyService()
        let wallet = Wallet.shared
        let viewModel = ConvertorViewModel(currencyService: currencyService,
                                           transactionDB: transactionDb,
                                           wallet: wallet)
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
                    let transactionObjs = self.transactionDb.realmObjects(type: TransactionObject.self)
                    var transactions: [TransactionModel] = []
                    transactionObjs?
                        .forEach { transactions.append( TransactionModel(transactionObject: $0))}
                    
                    let viewModel = TransactionViewModel(transactions: transactions)
                    return Observable.just(.push(viewModel: viewModel,
                                                    animated: true))
                default: return Observable.empty()
                }
        }
    }
}
