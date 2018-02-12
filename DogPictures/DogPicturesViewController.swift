//
//  ViewController.swift
//  DogPictures
//
//  Created by William Grand on 2/8/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import UIKit
import FLAnimatedImage

class DogPicturesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    let defaultSubreddit = "aww"
    let defaultFilter = "top"
    var posts : [RedditPost] = []
    
    @IBOutlet weak var statusIndicator: UIActivityIndicatorView!
    @IBOutlet weak var collectionView: UICollectionView!
    let numberOfCellsPerRow : Int = 3
    var openedCellFrame: CGRect?
    
    @IBOutlet weak var selectionView: UIView!
    @IBOutlet weak var selectedImage: FLAnimatedImageView!
    let animationDuration = 0.3
    
    // MARK: - Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: String(describing: DogPicturesCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: DogPicturesCollectionViewCell.self))
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setCellSize(cellsPerRow: numberOfCellsPerRow)
        loadPosts()
    }
    
    // MARK: - Data Handling
    
    func loadPosts() {
        
        statusIndicator.startAnimating()
        RedditLoader.loadPosts(fromSubreddit: defaultSubreddit, filter: .Top) { posts in
            self.posts = posts
            self.statusIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    
    // MARK: - Collection View Datasource Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: DogPicturesCollectionViewCell.self), for: indexPath) as? DogPicturesCollectionViewCell else {
            NSLog("Error dequeuing cell for index path: \(indexPath)")
            fatalError()
        }
        
        cell.loadCellWithImageURL(url: posts[indexPath.row].data.thumbnailURL, isAnimation: posts[indexPath.row].data.animated)
        return cell
    }
    
    // MARK: - Collection View Delegate Methods
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        
        selectedImage.sd_setImage(with: posts[indexPath.row].data.postURL)
        
        let translatedFrame = collectionView.convert(cell.frame, to: view)
        animateImageIn(fromFrame: translatedFrame)
    }
    
    // MARK: - Gesture Recognizers
    
    @IBAction func imageTapped(_ sender: Any) {
        
        animateImageOut(toFrame: openedCellFrame)
    }
    
    // MARK: - Supporting Functions
    
    // MARK: UI
    
    func setCellSize(cellsPerRow : Int) {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (view.bounds.width - (CGFloat(numberOfCellsPerRow - 1)) * spacing)/CGFloat(cellsPerRow)
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    // MARK: Animations
    
    func animateImageIn(fromFrame frame: CGRect) {
        
        self.selectedImage.frame = frame
        openedCellFrame = self.selectedImage.frame
        self.selectionView.isHidden = false
        self.selectionView.alpha = 0.0
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            self.selectionView.alpha = 1.0
            self.selectedImage.frame = UIScreen.main.bounds
        })
    }
    
    func animateImageOut(toFrame frame: CGRect?) {
        
        UIView.animate(withDuration: animationDuration, delay: 0, options: .curveEaseInOut, animations: {
            guard let destinationFrame = self.openedCellFrame else {
                self.selectionView.isHidden = false;
                return
            }
            self.selectedImage.frame = destinationFrame
            self.selectionView.alpha = 0.0
        }, completion: { completion in
            self.selectionView.isHidden = true
        })
    }
}

