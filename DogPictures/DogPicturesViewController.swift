//
//  ViewController.swift
//  DogPictures
//
//  Created by William Grand on 2/8/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import UIKit

class DogPicturesViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    var posts : [RedditPost] = []
    let numberOfCellsPerRow : CGFloat = 2.0
    
    let defaultSubreddit = "aww"
    let defaultFilter = "top"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib(nibName: String(describing: DogPicturesCollectionViewCell.self), bundle: Bundle.main), forCellWithReuseIdentifier: String(describing: DogPicturesCollectionViewCell.self))
        
        loadDataFromSubreddit(subreddit: defaultSubreddit, filter: defaultFilter)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            let spacing = flowLayout.minimumInteritemSpacing
            let cellWidth = (view.bounds.width - (numberOfCellsPerRow - 1) * spacing)/numberOfCellsPerRow
            flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    func loadDataFromSubreddit(subreddit: String, filter: String) {
        
        let endpoint = String(format: Constants.endPoint, subreddit, filter, 100)
        guard let url = URL(string: endpoint) else {
            NSLog("Failed to create URL from formatted string \(endpoint)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                NSLog("Failed to load subreddit data due to error \(error)")
                return
            }
            self.parseResponseData(data)
            }.resume()
    }
    
    func parseResponseData(_ data : Data?) {
        guard let data = data else {
            return
        }
        
        do {
            let encodeData = try JSONDecoder().decode(ListingRequestResult.self, from: data) as ListingRequestResult
            NSLog(encodeData.kind)
            
            self.posts = encodeData.data.children
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        catch {
            NSLog("Error parsing post data: \(error)")
        }
    }
    
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
}

