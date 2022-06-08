//
//  MovieDetailViewController.swift
//  MovieApp
//
//  Created by LongVu on 6/6/22.
//  Copyright © 2022 Longvu. All rights reserved.
//

import Reusable
import Combine
import Then
import UIKit
import Cosmos

final class MovieDetailViewController: UIViewController, Bindable {
    
    // MARK: - IBOutlets

    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var yearLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var languageLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var overviewLabel: UILabel!
    @IBOutlet private weak var seeMoreButton: UIButton!
    @IBOutlet private weak var actorCollectionView: UICollectionView!
    @IBOutlet private weak var writerCollectionView: UICollectionView!
    @IBOutlet private weak var overviewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var viewsLabel: UILabel!
    @IBOutlet private weak var ratedLabel: UILabel!
    @IBOutlet private weak var directorLabel: UILabel!
    @IBOutlet private weak var startRatingView: CosmosView!

    // MARK: - Properties
    
    var viewModel: MovieDetailViewModel!
    var cancelBag = CancelBag()

    // MARK: - Private properties

    private var options = Options()
    private var actors: [String] = []
    private var writers: [String] = []

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
        [actorCollectionView, writerCollectionView].forEach {
            $0?.register(cellType: ActorCell.self)
            $0?.alwaysBounceHorizontal = true
            $0?.delegate = self
            $0?.dataSource = self
        }
    }

    func bindViewModel() {
        let input = MovieDetailViewModel.Input(
            loadTrigger: .just(()),
            seeMoreTrigger: seeMoreButton.tapPublisher.asDriver()
        )
        let output = viewModel.transform(input, cancelBag: cancelBag)

        output.$movie
            .asDriver()
            .sink { [weak self] movie in
                self?.configView(movie: movie)
            }
            .store(in: cancelBag)

        output.$isExpandContent
            .sink { [weak self] in
                self?.changeLabelHeight(state: $0)
            }
            .store(in: cancelBag)

        output.$isLoading.subscribe(loadingSubscriber)
    }

    private func configView(movie: Movie?) {
        title = movie?.title

        posterImageView.sd_setImage(with: URL(string: movie?.poster ?? ""))
        nameLabel.text = movie?.title
        yearLabel.text = movie?.year
        durationLabel.text = movie?.runtime
        languageLabel.text = movie?.language
        overviewLabel.text = movie?.plot
        genreLabel.text = movie?.genre
        scoreLabel.text = movie?.metascore
        viewsLabel.text = movie?.imdbVotes
        ratedLabel.text = movie?.rated
        directorLabel.text = movie?.director
        startRatingView.rating = Double(movie?.imdbRating ?? "0") ?? 0.0
        startRatingView.text = "(\(movie?.imdbRating ?? ""))"
        actors = movie?.actors?.components(separatedBy: ",") ?? []
        actorCollectionView.reloadData()
        writers = movie?.writer?.components(separatedBy: ",") ?? []
        writerCollectionView.reloadData()
    }

    private func changeLabelHeight(state: Bool) {
        if state {
            UIView.animate(withDuration: 4, animations: {
                let width = UIScreen.main.bounds.width - 16
                let height = self.overviewLabel?.text?.heightWithConstrainedWidth(width: width) ?? 0
                self.overviewHeightConstraint?.constant = height + 10
                self.seeMoreButton.setTitle("<< Hide", for: .normal)
            })
        } else {
            UIView.animate(withDuration: 4, animations: {
                self.overviewHeightConstraint?.constant = 40
                self.seeMoreButton.setTitle("See More >>", for: .normal)
            })
        }
    }
}

// MARK: - Binders
extension MovieDetailViewController {

}

// MARK: - StoryboardSceneBased
extension MovieDetailViewController: StoryboardSceneBased {
    static var sceneStoryboard = Storyboards.movie
}

// MARK: -

extension MovieDetailViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionView === actorCollectionView ? actors.count : writers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(for: indexPath, cellType: ActorCell.self)
        if collectionView === actorCollectionView {
            cell.configCell(name: actors[indexPath.row])
        } else {
            cell.configCell(name: writers[indexPath.row])
        }
        return cell
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension MovieDetailViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    fileprivate struct Options {
        var itemSpacing: CGFloat = 8
        var lineSpacing: CGFloat = 8
        var itemsPerRow: Int = 3
        var sectionInsets: UIEdgeInsets = UIEdgeInsets(
            top: 10.0,
            left: 8.0,
            bottom: 10.0,
            right: 8.0
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenSize = UIScreen.main.bounds
        let paddingSpace = options.sectionInsets.left
            + options.sectionInsets.right
            + CGFloat(options.itemsPerRow - 1) * options.itemSpacing
        let availableWidth = screenSize.width - paddingSpace
        let widthPerItem = availableWidth / CGFloat(options.itemsPerRow) - paddingSpace
        let heightPerItem = widthPerItem * 1.5
        return CGSize(width: widthPerItem, height: heightPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return options.sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return options.lineSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return options.itemSpacing
    }
}
