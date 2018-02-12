//
//  DogPicturesCollectionViewCell.swift
//  DogPictures
//
//  Created by William Grand on 2/8/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import UIKit
import SDWebImage

class DogPicturesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var animatedIndicatorIcon: UIImageView!
    
    func loadCellWithImageURL(url: URL?, isAnimation: Bool) {
    
        animatedIndicatorIcon.isHidden = !isAnimation
        thumbnailImage.layer.cornerRadius = 0
        thumbnailImage.layer.masksToBounds = true
        thumbnailImage.sd_setImage(with: url, placeholderImage: nil)
    }
}
