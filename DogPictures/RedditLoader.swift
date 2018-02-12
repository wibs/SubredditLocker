//
//  RedditLoader.swift
//  DogPictures
//
//  Created by William Grand on 2/12/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import Foundation

enum PostFilter: String {
    case Top = "top"
    case New = "new"
}

class RedditLoader: NSObject {
    
    static func loadPosts(fromSubreddit subreddit: String, filter: PostFilter, completion: @escaping (([RedditPost]) -> Void)) {
        
        let endpoint = String(format: Constants.endPoint, subreddit, filter.rawValue, 100)
        guard let url = URL(string: endpoint) else {
            NSLog("Failed to create URL from formatted string \(endpoint)")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error {
                NSLog("Failed to load subreddit data due to error \(error)")
                return
            }
            guard let posts = self.parseResponseData(data) else {
                NSLog("Failed to receive parsed subreddit data")
                return
            }
            
            DispatchQueue.main.async {
                completion(posts)
            }
            
            }.resume()
    }
    
    private static func parseResponseData(_ data : Data?) -> [RedditPost]? {
        
        guard let data = data else {
            NSLog("Error unwrapping data")
            return nil
        }
        
        do {
            let encodeData = try JSONDecoder().decode(ListingRequestResult.self, from: data) as ListingRequestResult
            return encodeData.data.children
        }
        catch {
            NSLog("Error parsing post data: \(error)")
            return nil
        }
    }
}
