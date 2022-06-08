//
//  APIError.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

import Foundation

struct APIExpiredTokenError: APIError {
    var errorDescription: String? {
        return NSLocalizedString("api.expiredTokenError",
                                 value: "Access token is expired",
                                 comment: "")
    }
}

struct APIResponseError: APIError {
    let statusCode: Int?
    let message: String
    
    var errorDescription: String? {
        return message
    }
}
