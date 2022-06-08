//
//  BindableType.swift
//  MovieApp
//
//  Created by LongVu on 7/29/20.
//  Copyright © 2020 LongVu. All rights reserved.
//

import UIKit

public protocol Bindable: class {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! { get set }
    
    func bindViewModel()
}

extension Bindable where Self: UIViewController {
    public func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}
