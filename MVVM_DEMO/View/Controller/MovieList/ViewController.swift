//
//  ViewController.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/13/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import Alamofire
import Reachability

class ViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    let reachability = Reachability()!
    
    var movieViewModel: MovieViewModel = MovieViewModel()
    
    var arrMovie = [[String : AnyObject]]()
    
    var currentPage : Int = 1
    var isLoadingList : Bool = false
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Movie List"
        self.tableView.separatorStyle = .none
        
        if (NetworkReachabilityManager()?.isReachable)!{
            self.getMovieList(page: currentPage)
        }else{
            self.movieViewModel.retrieveData()
            self.tableView.reloadData()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        }
        catch {
            print(error.localizedDescription)
        }
        
        
    }
    
    //MARK:- reachabilityChanged Method
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            movieViewModel.displayAlert("Network Notice", andMessage: "Network Reachable via WiFi")
            self.tableView.reloadData()
        case .cellular:
            movieViewModel.displayAlert("Network Notice", andMessage: "Network Reachable via Cellular")
            self.tableView.reloadData()
        case .none:
            movieViewModel.displayAlert("Network Notice", andMessage: "Network Connection Lost.")
        }
    }
    
    //MARK:- getMovieList API
    func getMovieList(page: Int){
        
//        let url = API.SERVER_URL + "\(page)"
//        Alamofire.request(URL(string: url)!, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (responseObject) in
//            let response = self.formatResponse(data: responseObject)
//            let arr = response["results"] as! [[String : AnyObject]]
//            self.arrMovie.append(contentsOf: arr)
        //            self.movieViewModel.MovieList = self.arrMovie
        //            self.movieViewModel.getModels()
        //
        //            self.isLoadingList = false
        //            self.tableView.reloadData()
        //            self.movieViewModel.deleteAllRecords()
        //
        //        }
        
        MovieService.shared.getMovieList(page: page, completion: { (result) in
            if let result = result {
                
                if(result.count != 0)
                {
                    print(result)
                    self.arrMovie.append(contentsOf: result)
                    self.movieViewModel.MovieList = self.arrMovie
                    self.movieViewModel.getModels()
                    self.isLoadingList = false
                }
                else
                {
                    print("error")
                }
            }
            DispatchQueue.main.async {
                self.movieViewModel.deleteAllRecords()
                self.tableView.reloadData()
            }
        })
    }
    
    //MARK:- formatResponse
    func formatResponse(data:DataResponse<Any>)-> [String:AnyObject]
    {
        let responseObject = data.result.value as? [NSObject: AnyObject]
        let response = responseObject as? [String : AnyObject]
        return response ?? [:]
    }
    
    //MARK:- TABLEVIEW DATASOURCE AND DELEGATE
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieViewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell") as! TableViewCell
        cell.selectionStyle = .none
        
        let movie = movieViewModel.MovieArray[indexPath.row]
        
        cell.setProductData(movie: movie)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (NetworkReachabilityManager()?.isReachable)!{
            
            let movie = movieViewModel.MovieArray[indexPath.row]
            
            let ID = String(movie.id)
            
            let nextNavVc = self.storyboard!.instantiateViewController(withIdentifier: "MovieDetail_VC") as! MovieDetail_VC
            nextNavVc.StrID = ID
            nextNavVc.StrTitle = movie.title
            nextNavVc.StrPosterPath = movie.poster_path
            self.navigationController?.pushViewController(nextNavVc, animated: true)
            
        }
        else{
            movieViewModel.displayAlertWithOneOptionAndAction("Network Alert", andMessage: "Network Not Available.") {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    //MARK: - Use For Pegination -
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (NetworkReachabilityManager()?.isReachable)! {
            if (((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height ) && !isLoadingList){
                self.isLoadingList = true
                if(movieViewModel.MovieArray.count == 0)
                {
                    currentPage = 1
                }
                else
                {
                    currentPage += 1
                }
                
                print(currentPage)
                self.getMovieList(page: currentPage)
            }
        }
        
    }
    
    //MARK: - Deinit -
    deinit {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
}

