//
//  IAPManager.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import Foundation
import StoreKit

final class IAPManager: NSObject {
    
    static let shared: IAPManager = IAPManager()
    
    private let productIdentifiers: Set<String> = ["co.Kcin.nil.iapTest.1"]
    private(set) var products: [SKProduct] = [] {
        didSet {
            print("-- products details start --")
            products.forEach {
                print($0.productIdentifier)
                print($0.localizedTitle)
                print($0.localizedDescription)
                print($0.introductoryPrice ?? "introductoryPrice equal nil")
                print($0.price)
                print($0.priceLocale)
                print("----")
            }
            print("-- products details end --")
        }
    }

    private lazy var productRequest: SKProductsRequest = {
        let productRequest = SKProductsRequest(productIdentifiers: productIdentifiers)
        productRequest.delegate = self
        return productRequest
    }()
    
    override private init() {
        super.init()
        productRequest.start()
    }
    
}

extension IAPManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print("-- product request delegate callback start --")
        print(response.products)
        print(response.invalidProductIdentifiers)
        print("-- end --")
        products = response.products
    }

}
