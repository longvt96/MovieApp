//
//  GatewaysAssembler.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 LongVu. All rights reserved.
//

protocol GatewaysAssembler {
    func resolve() -> MovieGatewayType
}

extension GatewaysAssembler where Self: DefaultAssembler {
    func resolve() -> MovieGatewayType {
        return MovieGateway()
    }
}
