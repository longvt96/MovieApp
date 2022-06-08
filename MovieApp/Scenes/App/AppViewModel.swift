//
//  AppViewModel.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Combine

struct AppViewModel {
    let navigator: AppNavigatorType
    let useCase: AppUseCaseType
}

// MARK: - ViewModelType
extension AppViewModel: ViewModel {
    struct Input {
        let startTrigger: Driver<Void>
    }
    
    final class Output: ObservableObject {
        
    }
    
    func transform(_ input: Input, cancelBag: CancelBag) -> Output {
        input.startTrigger
            .handleEvents(receiveOutput: navigator.toMain)
            .sink()
            .store(in: cancelBag)
        
        return Output()
    }
}
