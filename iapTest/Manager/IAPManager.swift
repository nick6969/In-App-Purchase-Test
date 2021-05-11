//
//  IAPManager.swift
//  iapTest
//
//  Created by Nick on 5/2/21.
//

import Foundation
import StoreKit

enum IAPManagerState {
    case canNotMakePayment
    case canNotGotReceipt
    case paymentWaitingProcess
    case paymentSuccess
    case paymentFailure
    case paymentCancel
}

protocol IAPManagerCallback: AnyObject {
    func handleState(_ state: IAPManagerState)
}

final class IAPManager: NSObject {
    
    static let shared: IAPManager = IAPManager()
    private weak var callBack: IAPManagerCallback?
    private let productIdentifiers: Set<String> = ["co.Kcin.nil.iapTest.1"]
    private(set) var products: [SKProduct] = [] {
        didSet {
            print(msg: "-- products details start --")
            products.forEach {
                print($0.productIdentifier)
                print($0.localizedTitle)
                print($0.localizedDescription)
                print($0.price)
                print($0.priceLocale)
                print("----")
            }
            print(msg: "-- products details end --")
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
    
    func buy(product: SKProduct, callBack: IAPManagerCallback?) {
        self.callBack = callBack
        guard SKPaymentQueue.canMakePayments() else {
            callBack?.handleState(.canNotMakePayment)
            return
        }
        let payment: SKPayment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

}

extension IAPManager: SKProductsRequestDelegate {
    
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        print(msg: "-- product request delegate callback start --")
        print(response.products)
        print(response.invalidProductIdentifiers)
        print(msg: "-- end --")
        products = response.products
    }

    func requestDidFinish(_ request: SKRequest) {
        print(msg: "skrequest did finish.")
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        print(msg: "skrequest error: \(error.localizedDescription)")
    }

}

extension IAPManager: SKPaymentTransactionObserver {
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
        for transaction in transactions {
            
            switch transaction.transactionState {

            case .purchasing:
                break
            case .purchased:
                guard let receiptData: Data = getReceipts() else {
                    callBack?.handleState(.canNotGotReceipt)
                    continue
                }
                guard let transactionID: String = transaction.transactionIdentifier else { continue }
                let productID: String = transaction.payment.productIdentifier
                // Validate Receipt in Server to Apple Server.
                print(msg: "payment purchased")
                print("productID: \(productID)")
                print("transactionID: \(transactionID)")
                print(receiptData.base64EncodedString())
                callBack?.handleState(.paymentSuccess)
                SKPaymentQueue.default().finishTransaction(transaction)
            case .failed:
                if (transaction.error as? SKError)?.code != .paymentCancelled {
                    callBack?.handleState(.paymentFailure)
                } else {
                    callBack?.handleState(.paymentCancel)
                }
                SKPaymentQueue.default().finishTransaction(transaction)
            case .restored:
                break
            case .deferred:
                break
            @unknown default:
                break
            }
        }
    }
 
    private
    func getReceipts() -> Data? {
        guard let url: URL = Bundle.main.appStoreReceiptURL else { return nil }
        do {
            let canReach: Bool = try url.checkResourceIsReachable()
            guard canReach else { return nil }
            return try Data(contentsOf: url)
        } catch {
            return nil
        }
    }

}
