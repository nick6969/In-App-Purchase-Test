//
//  SKProductExtension.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import Foundation
import StoreKit

extension SKProduct {
    var localPrice: String? {
        let formatter = NumberFormatter()
        formatter.formatterBehavior = .behavior10_4
        formatter.numberStyle = .decimal
        formatter.locale = self.priceLocale
        guard let str = formatter.string(from: self.price) else { return nil }
        return "$" + str
    }
}
