//
//  MovieDetailViewModelTests.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp
import Combine
import XCTest

final class MovieDetailViewModelTests: XCTestCase {
    private var viewModel: MovieDetailViewModel!
    private var navigator: MovieDetailNavigatorMock!
    private var useCase: MovieDetailUseCaseMock!
    private var input: MovieDetailViewModel.Input!
    private var output: MovieDetailViewModel.Output!
    private var cancelBag: CancelBag!
    private var movie: Movie!

    // Triggers
    private let loadTrigger = PassthroughSubject<Void, Never>()
    private let seeMoreTrigger = PassthroughSubject<Void, Never>()

    override func setUp() {
        super.setUp()
        navigator = MovieDetailNavigatorMock()
        useCase = MovieDetailUseCaseMock()
        movie = Movie()
        movie.imdbID = "123"
        viewModel = MovieDetailViewModel(navigator: navigator, useCase: useCase, movie: movie)

        input = MovieDetailViewModel.Input(
            loadTrigger: loadTrigger.asDriver(),
            seeMoreTrigger: seeMoreTrigger.asDriver()
        )
        cancelBag = CancelBag()
        output = viewModel.transform(input, cancelBag: cancelBag)
    }

    func testLoadTrigger() {
        // act
        loadTrigger.send(())

        // assert
        wait {
            XCTAssert(self.useCase.getMovieDetailCalled)
        }
    }

    func testLoadTrigger_showLoading() {
        // arrange
        useCase.getMovieDetailReturnValue = Empty<Movie?, Error>(completeImmediately: false)
            .eraseToAnyPublisher()

        // act
        loadTrigger.send(())

        // assert
        wait {
            XCTAssert(self.useCase.getMovieDetailCalled)
            XCTAssert(self.output.isLoading)
        }
    }
}
