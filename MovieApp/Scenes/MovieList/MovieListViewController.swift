//
//  MovieListViewController.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Reusable
import Combine
import Then
import UIKit

final class MovieListViewController: UIViewController, Bindable {

    // MARK: - Config Collection

    enum Section {
      case movie
    }

    var dataSource: UICollectionViewDiffableDataSource<Section, Movie>! = nil

    // MARK: - IBOutlets
    
    private var collectionView: PagingCollectionView!

    private let emptyView: EmptyView = {
        let view = EmptyView.loadFromNib()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
        return view
    }()

    // MARK: - Properties
    
    var viewModel: MovieListViewModel!
    var cancelBag = CancelBag()

    let searchController = UISearchController(searchResultsController: nil)

    private let searchKeywordTrigger = CurrentValueSubject<String?, Never>("Marvel") // Set default search value
    private let reloadTrigger = PassthroughSubject<Void, Never>()
    private let selectedTrigger = PassthroughSubject<IndexPath, Never>()

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configView()
    }

    deinit {
        logDeinit()
    }
    
    // MARK: - Methods

    private func configView() {
        title = "Film List"
    
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false

        searchController.do {
            $0.searchResultsUpdater = self
            $0.hidesNavigationBarDuringPresentation = false
            $0.searchBar.sizeToFit()
            $0.searchBar.text = ("Marvel")
        }

        configureCollectionView()
        configureDataSource()

        emptyView.onTryAgain = { [weak self] in
            self?.reloadTrigger.send(())
        }
    }

    func bindViewModel() {
        let input = MovieListViewModel.Input(
            searchTrigger: searchKeywordTrigger.asDriver(),
            reloadTrigger: Publishers.Merge(collectionView.refreshTrigger, reloadTrigger).asDriver(),
            loadMoreTrigger: collectionView.loadMoreTrigger,
            selectedTrigger: selectedTrigger.asDriver()
        )
        let output = viewModel.transform(input, cancelBag: cancelBag)

        output.$movies
            .sink(receiveValue: { [weak self] movies in
                guard let self = self else {
                    return
                }
                let snapshot = self.snapshotForCurrentState(movies: movies)
                self.dataSource.apply(snapshot, animatingDifferences: false)
            })
            .store(in: cancelBag)

        output.$alert.subscribe(alertSubscriber)
        output.$isLoading.subscribe(loadingSubscriber)
        output.$isReloading.subscribe(collectionView.isRefreshing)
        output.$isLoadingMore.subscribe(collectionView.isLoadingMore)

        output.$errorMessage
            .sink(receiveValue: { [weak self] errorMessage in
                self?.collectionView.backgroundView = errorMessage == nil ? nil : self?.emptyView
                self?.collectionView.backgroundView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 200)
                self?.emptyView.configView(error: errorMessage)
            })
            .store(in: cancelBag)
    }
}

// MARK: - Binders
extension MovieListViewController {

}

// MARK: - StoryboardSceneBased
extension MovieListViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movie
}

// MARK: - UISearchResultsUpdating

extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchKeywordTrigger.send(searchController.searchBar.text)
    }
}

// MARK: - Config Collection

extension MovieListViewController {
    func configureCollectionView() {
        let collectionView = PagingCollectionView(frame: view.bounds, collectionViewLayout: generateLayout())
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.contentInset = UIEdgeInsets(top: 8.0, left: 0, bottom: 0, right: 0)
        collectionView.backgroundColor = .white
        collectionView.register(cellType: MovieListCell.self)
        collectionView.showsVerticalScrollIndicator = false
        collectionView.configRefreshControl()
        collectionView.delegate = self
        self.collectionView = collectionView
    }

    func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource
        <Section, Movie>(collectionView: collectionView) { (collectionView: UICollectionView, indexPath: IndexPath, movie: Movie)
            -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: MovieListCell.self)
            cell.configView(movie: movie)
            return cell
        }
    }

    func generateLayout() -> UICollectionViewLayout {
        let sectionProvider = { (sectionIndex: Int, _: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in            let rowItemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.5),
                                                     heightDimension: .fractionalWidth(2/3))
            let rowItem = NSCollectionLayoutItem(layoutSize: rowItemSize)
            rowItem.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 3, bottom: 3, trailing: 3)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                                   heightDimension: .fractionalWidth(2/3))

            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                           subitems: [rowItem, rowItem])
            
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }

        let layout = UICollectionViewCompositionalLayout(sectionProvider: sectionProvider)
        return layout
    }

    func snapshotForCurrentState(movies: [Movie]) -> NSDiffableDataSourceSnapshot<Section, Movie> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Movie>()
        snapshot.appendSections([Section.movie])
        let items = movies
        snapshot.appendItems(items)
        return snapshot
    }
}

// MARK: - UICollectionViewDelegate

extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTrigger.send(indexPath)
    }
}
