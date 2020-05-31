//
//  TransactionViewController.swift
//  CurrencyApp
//
//  Created by Dushyant_Singh on 31/5/20.
//  Copyright © 2020 Dushyant Singh. All rights reserved.
//

import UIKit

class TransactionViewController: UIViewController, ViewControllerProtocol {
    typealias ViewModelType = TransactionViewModel
    var viewModel: TransactionViewModel!
    
    @IBOutlet weak var transactionTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.title
        setupTableView()
    }
}

extension TransactionViewController: UITableViewDataSource {
    private func setupTableView() {
        transactionTableView
            .registerCellClassForNib(cellClass: TransactionTableViewCell.self)
        transactionTableView.dataSource = self
    }
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "TransactionTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID)
            as? TransactionTableViewCell
            else { return  UITableViewCell() }
        return cell
    }
}
