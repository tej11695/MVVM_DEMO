//
//  MovieService.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/17/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class MovieService {
    
    static let shared = MovieService()
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    var dataTask: URLSessionDataTask?
    
    func getMovieList(page: Int, completion:@escaping  (_ result: [[String : AnyObject]]?) -> Void) {
        
        let ReqURL = API.SERVER_URL + "\(page)"
        let request = NSMutableURLRequest(url: NSURL(string: ReqURL)! as URL)
        //request.setValue(self.stripeTool.getBasicAuth(), forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        self.dataTask = self.defaultSession.dataTask(with: request as URLRequest) { (data, response, error) in
            
            if let error = error {
                print(error)
                completion(nil)
            }
            else if let httpResponse = response as? HTTPURLResponse {
                if(httpResponse.statusCode == 200) {
                    if let data = data {
                        let json = try! JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSMutableDictionary
                        print("json:-",json)
                        let arrMovie = json["results"] as? [[String : AnyObject]]
                        print("arrMovie:-",arrMovie!)
                        completion((arrMovie))
                    }
                }
                else {
                    completion(nil)
                }
            }
        }
        self.dataTask?.resume()
    }
}




