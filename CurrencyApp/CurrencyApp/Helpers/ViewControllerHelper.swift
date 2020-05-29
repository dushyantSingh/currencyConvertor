//
//  ViewControllerHelper.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 29/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

extension UIViewController {
    public static func make<T>(viewController: T.Type) -> T {
        let viewControllerName = String(describing: viewController)
        
        let storyboard = UIStoryboard(name: viewControllerName, bundle: Bundle(for: viewController as! AnyClass))
        
        guard let viewController = storyboard.instantiateViewController(withIdentifier: viewControllerName) as? T else {
            fatalError("Unable to create ViewController: \(viewControllerName) from storyboard: \(storyboard)")
        }
        return viewController
    }
}
