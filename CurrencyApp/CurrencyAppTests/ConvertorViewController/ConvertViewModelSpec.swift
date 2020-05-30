//
//  ConvertViewModelSpec.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 30/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import Quick
import Nimble
import RxSwift

@testable import CurrencyApp

class ConvertorViewModelSpec: QuickSpec {
    override func spec() {
        describe("ConvertorViewModel Test") {
            var subject: ConvertorViewModel!
            var disposeBag: DisposeBag!
            beforeEach {
                subject = ConvertorViewModel()
                disposeBag = DisposeBag()
            }
            context("When convert button is triggered") {
                it("should emit event showConvertAlert") {
                    var showConvertAlertEvent = false
                    subject.events.subscribe(onNext: { event in
                        if case event = ConvertViewModelEvents.showConvertAlert {
                            showConvertAlertEvent = true
                        }
                    })
                    .disposed(by: disposeBag)
                    subject.convertButtonClicked.onNext(())
                    expect(showConvertAlertEvent).to(beTrue())
                }
            }
        }
    }
}
