//
//  APIErrorBase.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import Foundation

public protocol APIError: LocalizedError {
    var statusCode: Int? { get }
}

public extension APIError {  // swiftlint:disable:this no_extension_access_modifier
    var statusCode: Int? { return nil }
}

public struct APIInvalidResponseError: APIError {
    
    public init() {
        
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.invalidResponseError",
                                 value: "Invalid server response",
                                 comment: "")
    }
}

public struct APIUnknownError: APIError {
    
    public let statusCode: Int?
    
    public init(statusCode: Int?) {
        self.statusCode = statusCode
    }
    
    public var errorDescription: String? {
        return NSLocalizedString("api.unknownError",
                                 value: "Unknown API error",
                                 comment: "")
    }
}
