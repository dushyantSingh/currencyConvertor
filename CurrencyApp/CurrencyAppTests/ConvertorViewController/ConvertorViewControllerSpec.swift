//
//  ConvertorViewControllerSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble

@testable import CurrencyApp

class ConvertorViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ConvertorViewController Test") {
            var subject: ConvertorViewController!
            beforeEach {
                subject = UIViewController.make(viewController: ConvertorViewController.self)
                subject.viewModel = ConvertorViewModel()
                _ = subject.view
            }
            context("when view loads") {
                it("should have title") {
                    expect(subject.title).to(equal("Convert"))
                }
            }
        }
    }
}
