//
//  ScreenLoadingType.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22
//  Copyright © 2020 LongVu. All rights reserved.
//

public enum ScreenLoadingType<Input> {
    case loading(Input)
    case reloading(Input)
}
