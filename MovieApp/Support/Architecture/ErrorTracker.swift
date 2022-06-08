//
//  ErrorTracker.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2020 LongVu. All rights reserved.
//

import Combine

public typealias ErrorTracker = PassthroughSubject<Error, Never>

extension Publisher where Failure: Error {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Failure> {
        return handleEvents(receiveCompletion: { completion in
            if case let .failure(error) = completion {
                errorTracker.send(error)
            }
        })
        .eraseToAnyPublisher()
    }
}
