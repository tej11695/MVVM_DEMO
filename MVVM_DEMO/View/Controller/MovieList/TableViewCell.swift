//
//  TableViewCell.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/13/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

class TableViewCell: UITableViewCell {
    
    var ImageURL:String!
    var movieViewModel: MovieViewModel = MovieViewModel()
    
    @IBOutlet var ImageCell: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblDesc: UILabel!
    @IBOutlet var viewCell: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func setProductData(movie:MovieModel)
    {
        self.lblTitle.text = movie.title
        self.lblDesc.text = movie.overview
        
        
        if(movie.poster_path != nil)
        {
            ImageURL = "https://image.tmdb.org/t/p/w185" + movie.poster_path
        }
        else
        {
            ImageURL = "https://image.tmdb.org/t/p/w185"
        }
        
        if (NetworkReachabilityManager()?.isReachable)!{
            self.movieViewModel.SetImage(Image: self.ImageCell, StrURL: ImageURL)
        }else{
            self.movieViewModel.SetImage(Image: self.ImageCell, StrURL: movie.poster_path)
        }
        
    }
    
}
