//
//  APIResponse.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

public struct APIResponse<T> {
    public var header: ResponseHeader?
    public var data: T
    
    public init(header: ResponseHeader?, data: T) {
        self.header = header
        self.data = data
    }
}
