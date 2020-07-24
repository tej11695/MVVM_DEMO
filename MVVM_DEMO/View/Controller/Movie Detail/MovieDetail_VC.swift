//
//  MovieDetail_VC.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/17/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class MovieDetail_VC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var StrID:String!
    var StrTitle:String!
    var StrPosterPath:String!
    
    var arr = [String]()
    var values = [String:AnyObject]()
    
    var movieViewModel: MovieViewModel = MovieViewModel()
    
    @IBOutlet var bgImageHeight: NSLayoutConstraint!
    @IBOutlet var imgBackGround: UIImageView!
    @IBOutlet var imgView: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tableViewHeight: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = self.StrTitle
        self.addBackButton()
        
        if (NetworkReachabilityManager()?.isReachable)!{
            self.getMovieDetails()
        }
        else{
            movieViewModel.displayAlertWithOneOptionAndAction("Network Alert", andMessage: "Network Not Available.") {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    //MARK:- addBackButton Method
    func addBackButton() {
        let backButton = UIButton(type: .custom)
        backButton.setImage(UIImage(named: "Back"), for: .normal)
        backButton.addTarget(self, action: #selector(self.backAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK:- getMovieList API
    func getMovieDetails(){
        
        let url = "https://api.themoviedb.org/3/movie/\(self.StrID ?? "")?api_key=14bc774791d9d20b3a138bb6e26e2579&language=en-US"
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) in
            
            let response = self.formatResponse(data: responseObject)
            print(response)
            
            self.values = response
            self.arr = response.keys.sorted()
            
            let img = response["backdrop_path"] as? String ?? ""
            let imageURL = "https://image.tmdb.org/t/p/w500" + img
            self.movieViewModel.SetImage(Image: self.imgBackGround, StrURL: imageURL)
            
            let imgURL = "https://image.tmdb.org/t/p/w185" + self.StrPosterPath
            self.movieViewModel.SetImage(Image: self.imgView, StrURL: imgURL)
            
            let multiplier = UIScreen.main.bounds.width / 500;
            let height = multiplier * 281
            self.bgImageHeight.constant = height
            self.view.updateConstraintsIfNeeded()
            
            self.tableViewHeight.constant = CGFloat.greatestFiniteMagnitude
            self.tableView.reloadData()
            
            UIView.animate(withDuration: 0, animations: {
                self.tableView.layoutIfNeeded()
            }) { (complete) in
                var heightOfTableView: CGFloat = 0.0
                
                heightOfTableView = self.tableView.contentSize.height
                self.tableViewHeight.constant = heightOfTableView
            }
            self.view.updateConstraintsIfNeeded()
        }
    }
    
    //MARK:- formatResponse
    func formatResponse(data:DataResponse<Any>)-> [String:AnyObject]
    {
        let responseObject = data.result.value as? [NSObject: AnyObject]
        let response = responseObject as? [String : AnyObject]
        return response ?? [:]
    }
    
    //MARK: - UITableview delegate and Datasource -
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "DetailsCell") as! DetailsCell
        cell.selectionStyle = .none
        cell.lblName.text = self.arr[indexPath.row]
        
        let value = self.values[self.arr[indexPath.row]]
        if value is String{
            cell.lblValue.text = value as? String ?? ""
        }else if value is Bool{
            cell.lblValue.text = "\(value as? Bool ?? false)"
        }else if value is Int{
            cell.lblValue.text = "\(value as? Int ?? 0)"
        }else if value is Double{
            cell.lblValue.text = "\(value as? Double ?? 0.0)"
        }else if value is Array<Any>{
            let arr = value as! Array<[String: AnyObject]>
            cell.lblValue.text = self.movieViewModel.arrayToString(array: arr)
        }else{
            cell.lblValue.text = "N/A"
        }
        return cell
    }
    
}
