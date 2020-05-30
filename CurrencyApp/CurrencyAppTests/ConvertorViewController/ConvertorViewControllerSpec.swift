//
//  ConvertorViewControllerSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class ConvertorViewControllerSpec: QuickSpec {
    override func spec() {
        describe("ConvertorViewController Test") {
            var subject: ConvertorViewController!
            var disposeBag: DisposeBag!
            beforeEach {
                subject = UIViewController.make(viewController: ConvertorViewController.self)
                disposeBag = DisposeBag()
                subject.viewModel = ConvertorViewModel()
                 _ = subject.view
            }
            context("when view loads") {
                it("should have title") {
                    expect(subject.title).to(equal("Convert"))
                }
            }
            context("when convert button is clicked") {
                it("should trigger convertButtonClicked in view model") {
                    var convertButtonTriggered = false
                    subject.viewModel.convertButtonClicked
                        .subscribe(onNext: { _ in
                            convertButtonTriggered = true
                        })
                        .disposed(by: disposeBag)
                    subject.convertButton.sendActions(for: .touchUpInside)
                    expect(convertButtonTriggered).to(beTrue())
                }
            }
        }
    }
}
