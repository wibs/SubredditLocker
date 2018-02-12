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
        thumbnailImage.sd_setImage(with: url, placeholderImage: nil)
        animatedIndicatorIcon.isHidden = !isAnimation
    }
}
