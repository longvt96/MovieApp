//
//  ActivityTracker.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2020 LongVu. All rights reserved.
//

import Combine
import UIKit

public typealias ActivityTracker = CurrentValueSubject<Bool, Never>

extension Publisher where Failure: Error {
    public func trackActivity(_ activityTracker: ActivityTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveSubscription: { _ in
            activityTracker.send(true)
        }, receiveCompletion: { _ in
            activityTracker.send(false)
        })
        .eraseToAnyPublisher()
    }
}
