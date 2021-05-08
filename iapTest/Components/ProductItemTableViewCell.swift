//
//  ProductItemTableViewCell.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import UIKit
import StoreKit

final class ProductItemTableViewCell: UITableViewCell {
    
    private let titleLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .black
        return label
    }()
    private let amountLabel: UILabel = {
        let label: UILabel = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.textColor = .darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(amountLabel)
        
        titleLabel
            .mLayChain(.centerY, .equal, contentView)
            .mLayChain(.leading, .equal, contentView, constant: 40)
        
        amountLabel
            .mLayChain(.centerY, .equal, contentView)
            .mLayChain(.trailing, .equal, contentView, constant: -40)
    }
 
    func setup(with product: SKProduct) {
        titleLabel.text = product.localizedTitle
        amountLabel.text = product.localPrice
    }
    
}
