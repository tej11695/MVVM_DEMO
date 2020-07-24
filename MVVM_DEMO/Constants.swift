//
//  Constants.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/13/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit

struct API {
    
    //Base API
    static var SERVER_URL = "https://api.themoviedb.org/3/discover/movie?api_key=14bc774791d9d20b3a138bb6e26e2579&language=en-US&sort_by=popularity.desc&include_adult=false&include_video=false&page="
    static let IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w185"
    static let BG_IMAGE_BASE_URL = "https://image.tmdb.org/t/p/w500"
    static var BASE_URL = API.SERVER_URL
}

