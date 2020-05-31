//
//  ModelConvertor.swift
//  CurrencyAppTests
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//
import Quick
import Nimble

@testable import CurrencyApp

class ModelConvertorSpec: QuickSpec {
    override func spec() {
        describe("ModelConvertor Test") {
            context("when convertor returns"){
                it("should return correct model for transaction1") {
                    let cellModel = ModelConvertor.convertToCellModel(TransactionStub.transaction1)
                    let dateString = Date().toString(.tableCell)
                    expect(cellModel.dateString).to(equal(dateString))
                    expect(cellModel.idString).to(equal("CVRT0001"))
                    expect(cellModel.exchangeString)
                        .to(equal("SGD 1000.00 to EUR 750.00"))
                    expect(cellModel.exchangeRateString)
                        .to(equal("@ SGD 1 = EUR 0.75"))
                }
                it("should return correct model for transaction3") {
                    let cellModel = ModelConvertor.convertToCellModel(TransactionStub.transaction3)
                    let dateString = Date().toString(.tableCell)
                    expect(cellModel.dateString).to(equal(dateString))
                    expect(cellModel.idString).to(equal("CVRT0003"))
                    expect(cellModel.exchangeString)
                        .to(equal("SGD 2000.00 to INR 100000.00"))
                    expect(cellModel.exchangeRateString)
                        .to(equal("@ SGD 1 = INR 50.00"))
                }
            }
        }
    }
}
