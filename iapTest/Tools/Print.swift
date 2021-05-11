//
//  Print.swift
//  iapTest
//
//  Created by Nick on 5/11/21.
//

import Foundation

public func print<T>(msg: T, file: String = #file, method: String = #function, line: Int = #line) {
    Swift.print("\((file as NSString).lastPathComponent):\(line), \(method): \(msg)")
}
