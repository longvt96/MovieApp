//
//  MovieListViewControllerTests.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp
import Reusable
import UIKit
import XCTest

final class MovieListViewControllerTests: XCTestCase {
    var viewController: MovieListViewController!

    override func setUp() {
        super.setUp()
        viewController = MovieListViewController.instantiate()
    }

    func test_ibOutlets() {
        _ = viewController.view
        XCTAssertNotNil(viewController.collectionView)
    }
}
