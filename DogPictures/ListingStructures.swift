//
//  Post.swift
//  DogPictures
//
//  Created by William Grand on 2/8/18.
//  Copyright © 2018 William Grand. All rights reserved.
//

import Foundation

struct Constants {
    static let endPoint: String = "http://www.reddit.com/r/%@/%@.json?limit=%d"
}

struct ListingRequestResult : Codable {
    let kind : String
    let data : ListingData
}

struct ListingData : Codable {
    let children : [RedditPost]
}

struct RedditPost : Codable {
    let kind : String
    let data : PostData
}

struct PostData : Codable {
    let over_18 : Bool
    private let thumbnail : String
    private let url : String
    
    var animated : Bool {
        //TODO: This is an incredibly naive approach
        return url.hasSuffix("gif") || url.hasSuffix("gifv")
    }

    var postURL : URL? {
        return URL(string: thumbnail)
    }
    
    var thumbnailURL : URL? {
        return URL(string: thumbnail)
    }
}
