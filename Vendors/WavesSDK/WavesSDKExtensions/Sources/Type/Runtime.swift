//
//  Runtime.swift
//  WavesWallet-iOS
//
//  Created by Prokofev Ruslan on 10/08/2018.
//  Copyright © 2018 Waves Platform. All rights reserved.
//

import Foundation

public enum Runtime {
    public static func swizzle(for forClass: AnyClass, original: Selector, swizzled: Selector) {
        let originalMethod = class_getInstanceMethod(forClass, original)!
        let swizzledMethod = class_getInstanceMethod(forClass, swizzled)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }

    public static func swizzleClass(for forClass: AnyClass, original: Selector, swizzled: Selector) {
        let originalMethod = class_getClassMethod(forClass, original)!
        let swizzledMethod = class_getClassMethod(forClass, swizzled)!
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

public struct Swizzle {

    public typealias Initializer = (() -> Void)
    public let initializers: [Initializer]

    public init(initializers: [Initializer]) {
        self.initializers = initializers
    }

    public func start() {
        initializers.forEach { call in
            call()
        }
    }
}
