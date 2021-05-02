//
//  DemoVC.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import UIKit
import StoreKit

final class DemoVC: UIViewController {
    
    private lazy var tableView: UITableView = {
        let tableView: UITableView = UITableView()
        tableView.register(ProductItemTableViewCell.self,
                           forCellReuseIdentifier: String(describing: ProductItemTableViewCell.self))
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    private var models: [SKProduct] {
        return IAPManager.shared.products
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        tableView.mLaySafe(pin: .allZero)
    }
    
}

extension DemoVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProductItemTableViewCell.self)) as? ProductItemTableViewCell else {
            return UITableViewCell()
        }
        cell.setup(with: models[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
}
