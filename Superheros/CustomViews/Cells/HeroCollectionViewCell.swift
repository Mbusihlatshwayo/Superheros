//
//  HeroCollectionViewCell.swift
//  Superheros
//
//  Created by Mbusi Hlatshwayo on 7/27/21.
//

import UIKit

class HeroCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var heroImageView: MSHeroImageView!
    @IBOutlet weak var heroNameLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        heroNameLabel.adjustsFontSizeToFitWidth = true
        heroImageView.isUserInteractionEnabled = false
        heroNameLabel.isUserInteractionEnabled = false
    }

    func set(hero: Character)
    {
        heroNameLabel.text = hero.name
        guard let imagePath = hero.thumbnail?.path, let imageExtension = hero.thumbnail?.thumbnailExtension else {
            return
        }
        heroImageView.downloadImage(from: "\(imagePath)/\(Constants.kMediumImageSize).\(imageExtension)")
    }
}
