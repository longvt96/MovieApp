//
//  CancelBag.swift
//  MovieApp
//
//  Created by LongVu on 7/21/20.
//  Copyright © 2020 LongVu. All rights reserved.
//

import Combine

open class CancelBag {
    public var subscriptions = Set<AnyCancellable>()
    
    public func cancel() {
        subscriptions.forEach { $0.cancel() }
        subscriptions.removeAll()
    }
}

extension AnyCancellable {
    public func store(in cancelBag: CancelBag) {
        cancelBag.subscriptions.insert(self)
    }
}

