//
//  AlertMessage.swift
//  MovieApp
//
//  Created by Long Vu on 06/06/2022.
//

import Combine
import Then

public struct AlertMessage {
    public var title = ""
    public var message = ""
    public var isShowing = false
    
    public init(title: String, message: String, isShowing: Bool) {
        self.title = title
        self.message = message
        self.isShowing = isShowing
    }
    
    public init() {
        
    }
}

public extension AlertMessage {  // swiftlint:disable:this no_extension_access_modifier
    init(error: Error) {
        self.title = "Error"
        let message = error.localizedDescription
        self.message = message
        self.isShowing = !message.isEmpty
    }
}

extension AlertMessage: Then { }

