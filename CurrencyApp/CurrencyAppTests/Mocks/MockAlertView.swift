//
//  MockAlertViewPresenter.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import RxSwift
@testable import CurrencyApp

class MockAlertView: AlertViewPresenterType {
    var isAlertViewPresented = false
    var title = ""
    var message = ""
    var actions: [AlertModel] = []
    var convertButtonClicked = PublishSubject<AlertModelEvent>()
    
    func present(title: String,
                 message: String,
                 actions: [AlertModel],
                 viewController: UIViewController) -> Observable<AlertModelEvent> {
        isAlertViewPresented = true
        self.title = title
        self.message = message
        self.actions = actions
        return convertButtonClicked.asObservable()
    }
}
