//
//  AppDelegate.swift
//  MovieApp
//
//  Created by Long Vu on 06/06/2022.
//

import UIKit
import Combine
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var assembler: Assembler = DefaultAssembler()
    var cancelBag = CancelBag()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        
        if NSClassFromString("XCTest") != nil { // test
            window.rootViewController = UnitTestViewController()
            window.makeKeyAndVisible()
        } else {
            enableIQKeyboardManager()
            bindViewModel(window: window)
        }
    }

    private func bindViewModel(window: UIWindow) {
        let vm: AppViewModel = assembler.resolve(window: window)
        let input = AppViewModel.Input(startTrigger: Driver.just(()))
        _ = vm.transform(input, cancelBag: cancelBag)
    }
}

// MARK: - Config

extension AppDelegate {
    // MARK: - IQKeyboardManager
    private func enableIQKeyboardManager() {
        let manager = IQKeyboardManager.shared
        manager.do {
            $0.enable = true
            $0.previousNextDisplayMode = .default
            $0.toolbarDoneBarButtonItemText = "Done"
            $0.shouldResignOnTouchOutside = true
        }
    }
}

