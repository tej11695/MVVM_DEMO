//
//  Product.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/13/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

class MovieModel: NSObject {
    
    var id : Int!
    var title : String!
    var overview : String!
    var poster_path : String!
    
    init(dictionary: [String:Any])
    {
        id = dictionary["id"] as? Int
        title = dictionary["title"] as? String
        overview = dictionary["overview"] as? String
        poster_path = dictionary["poster_path"] as? String
    
    }
    init(id: Int, title: String, overview: String, poster_path: String)
    {
        self.id = id
        self.title = title
        self.overview = overview
        self.poster_path = poster_path
    }
    public class func modelsFromArray(array:[[String:Any]]) -> [MovieModel]
    {
        var models:[MovieModel]  = []
        for item in array
        {
            models.append(MovieModel.init(dictionary:item))
        }
        return models
    }
    
}
