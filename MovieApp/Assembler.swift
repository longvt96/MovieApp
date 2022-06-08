//
//  Assembler.swift
//  MovieApp
//
//  Created by Long Vu on 06/06/2022.
//

protocol Assembler: AnyObject,
                    GatewaysAssembler,
                    MovieListAssembler,
                    MovieDetailAssembler,
                    AppAssembler {
    
}

final class DefaultAssembler: Assembler {
    
}
