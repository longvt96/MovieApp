//
//  MovieListViewModelTests.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

@testable import MovieApp
import Combine
import XCTest

final class MovieListViewModelTests: XCTestCase {
    private var viewModel: MovieListViewModel!
    private var navigator: MovieListNavigatorMock!
    private var useCase: MovieListUseCaseMock!
    private var input: MovieListViewModel.Input!
    private var output: MovieListViewModel.Output!
    private var cancelBag: CancelBag!

    // Triggers
    private let searchTrigger = PassthroughSubject<String?, Never>()
    private let reloadTrigger = PassthroughSubject<Void, Never>()
    private let loadMoreTrigger = PassthroughSubject<Void, Never>()
    private let selectedTrigger = PassthroughSubject<IndexPath, Never>()

    override func setUp() {
        super.setUp()
        navigator = MovieListNavigatorMock()
        useCase = MovieListUseCaseMock()
        viewModel = MovieListViewModel(navigator: navigator, useCase: useCase)

        input = MovieListViewModel.Input(
            searchTrigger: searchTrigger.asDriver(),
            reloadTrigger: reloadTrigger.asDriver(),
            loadMoreTrigger: loadMoreTrigger.asDriver(),
            selectedTrigger: selectedTrigger.asDriver())
        cancelBag = CancelBag()
        output = viewModel.transform(input, cancelBag: cancelBag)
    }

    func testSearchTrigger() {
        // act
        searchTrigger.send("test")

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 1)
        }
    }

    func testSearchTrigger_noSuccess() {
        let getMovieListReturnValue = PassthroughSubject<MovieResponse?, Error>()
        useCase.getMovieListReturnValue = getMovieListReturnValue
            .eraseToAnyPublisher()

        // act
        searchTrigger.send("test")
        wait {
            getMovieListReturnValue.send(MovieResponse(movies: [], response: "False", error: nil, totalResults: nil))
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 0)
        }
    }

    func testSearchTrigger_showError() {
        let getMovieListReturnValue = PassthroughSubject<MovieResponse?, Error>()
        useCase.getMovieListReturnValue = getMovieListReturnValue
            .eraseToAnyPublisher()
        
        // act
        searchTrigger.send("test")
        getMovieListReturnValue.send(completion: .failure(TestError()))

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssert(self.output.alert.isShowing)
        }
    }

    func testSearchTrigger_showLoading() {
        // arrange
        useCase.getMovieListReturnValue =  Empty<MovieResponse?, Error>(completeImmediately: false)
            .eraseToAnyPublisher()

        // act
        searchTrigger.send("test")

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssert(self.output.isLoading)
        }
    }

    func testReloadTrigger() {
        // act
        searchTrigger.send("test")
        wait {
            self.reloadTrigger.send(())
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 1)
        }
    }

    func testReloadTrigger_noSuccess() {
        let getMovieListReturnValue = PassthroughSubject<MovieResponse?, Error>()
        useCase.getMovieListReturnValue = getMovieListReturnValue
            .eraseToAnyPublisher()

        // act
        searchTrigger.send("test")
        wait {
            self.reloadTrigger.send(())
        }
        wait {
            getMovieListReturnValue.send(MovieResponse(movies: [], response: "False", error: nil, totalResults: nil))
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 0)
        }
    }

    func testReloadTrigger_showError() {
        let getMovieListReturnValue = PassthroughSubject<MovieResponse?, Error>()
        useCase.getMovieListReturnValue = getMovieListReturnValue
            .eraseToAnyPublisher()
        
        // act
        searchTrigger.send("test")
        wait {
            self.reloadTrigger.send(())
        }
        getMovieListReturnValue.send(completion: .failure(TestError()))

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssert(self.output.alert.isShowing)
        }
    }

    func testReloadTrigger_showLoading() {
        // arrange
        useCase.getMovieListReturnValue =  Empty<MovieResponse?, Error>(completeImmediately: false)
            .eraseToAnyPublisher()

        // act
        searchTrigger.send("test")
        wait {
            self.reloadTrigger.send(())
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssert(self.output.isLoading)
        }
    }

    func testLoadMoreTrigger() {
        // act
        searchTrigger.send("test")
        wait {
            self.loadMoreTrigger.send(())
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 2)
        }
    }

    func testLoadMoreTrigger_noSuccess() {
        let getMovieListReturnValue = PassthroughSubject<MovieResponse?, Error>()
        useCase.getMovieListReturnValue = getMovieListReturnValue
            .eraseToAnyPublisher()

        // act
        searchTrigger.send("test")
        wait {
            self.loadMoreTrigger.send(())
        }
        wait {
            getMovieListReturnValue.send(MovieResponse(movies: [], response: "False", error: nil, totalResults: nil))
        }

        // assert
        wait {
            XCTAssert(self.useCase.getMovieListCalled)
            XCTAssertEqual(self.output.movies.count, 0)
        }
    }

    func testSelectTrigger() {
        // act
        searchTrigger.send("test")
        wait {
            self.selectedTrigger.send(IndexPath(row: 0, section: 0))
        }

        // assert
        wait {
            XCTAssert(self.navigator.toMovieDetailCalled)
        }
    }
}
