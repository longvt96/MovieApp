//
//  ActorCell.swift
//  MovieApp
//
//  Created by Long Vu on 07/06/2022.
//

import UIKit
import SDWebImage
import Reusable

final class ActorCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configCell(name: String) {
        nameLabel.text = name
    }

}
