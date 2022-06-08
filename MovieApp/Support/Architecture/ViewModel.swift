//
//  ViewModelType.swift
//  MovieApp
//
//  Created by LongVu on 7/14/20.
//  Copyright © 2020 LongVu. All rights reserved.
//

import Combine

public protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output
}

