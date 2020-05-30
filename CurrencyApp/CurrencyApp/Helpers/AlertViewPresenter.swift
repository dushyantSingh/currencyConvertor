//
//  AlertViewPresenter.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit
import RxSwift

protocol AlertViewPresenterType {
    func present(title: String,
                 message: String,
                 actions: [AlertModel],
                 viewController: UIViewController) -> Observable<AlertModelEvent>
}

class AlertViewPresenter: AlertViewPresenterType {
    func present(title: String, message: String, actions: [AlertModel], viewController: UIViewController) -> Observable<AlertModelEvent> {
        return Observable.create { observer in
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            for (index, action) in actions.enumerated() {
                let action = UIAlertAction(title: action.title,
                                           style: action.style) { _ in
                                            observer.onNext(.alertButtonTapped(buttonIndex: index))
                                            observer.onCompleted()
                }
                alertController.addAction(action)
            }
            viewController.present(alertController,
                                   animated: true,
                                   completion: nil)
            return Disposables.create { alertController.dismiss(animated: true)}
        }
    }
}
