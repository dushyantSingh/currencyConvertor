//
//  MockNavigationController.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class MockNavigationController: UINavigationController {
    var pushViewControllerCalled = false
    var popViewControllerCalled = false
    var viewController: UIViewController!
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        pushViewControllerCalled = true
        self.viewController = viewController
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        popViewControllerCalled = true
        return nil
    }
}
