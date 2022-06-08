//
//  MovieListCell.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import UIKit
import Reusable

final class MovieListCell: UICollectionViewCell, NibReusable {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var movieImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configView(movie: Movie) {
        titleLabel.text = movie.title
        yearLabel.text = "Year: \(movie.year ?? "")"
        movieImageView.sd_setImage(with: URL(string: movie.poster ?? ""))
    }
}
