//
//  ProductViewModel.swift
//  MVVM_DEMO
//
//  Created by esparkbiz on 2/13/20.
//  Copyright © 2020 esparkbiz. All rights reserved.
//

import UIKit
import CoreData
import SDWebImage

class MovieViewModel: NSObject {
    
    var MovieArray = Array<MovieModel>()
    var MovieList = [[String : AnyObject]]()
    var movieService = MovieService()

    override init() {
        
    }
    
    func numberOfRowsInSection() -> Int {
        return MovieArray.count
    }
    
    func getModels()
    {
        MovieArray = MovieModel.modelsFromArray(array: MovieList)
    }
    
    //MARK:- SetImage method
    func SetImage(Image:UIImageView,StrURL:String)
    {
        
        Image.sd_setImage(with: URL(string: StrURL), placeholderImage: UIImage(named: "Demo-Image.png"), options: [.continueInBackground,.refreshCached,.lowPriority], completed: {(image,error,cacheType,url) in
            
            if error == nil
            {
                Image.image = image
            }
            else
            {
                Image.image =  UIImage(named: "Demo-Image.png")
            }
        })
    }
    
    //MARK:- arrayToString method
    func arrayToString(array: Array<[String: AnyObject]>) -> String {
        var arrStrings = [String]()
        for data in array{
            arrStrings.append(data["name"] as? String ?? "")
        }
        let formattedArray = (arrStrings.map{String($0)}).joined(separator: ",")
        return formattedArray
    }
    
    //MARK: - CoreData Methods -
    func createData(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let userEntity = NSEntityDescription.entity(forEntityName: "Movie", in: managedContext)!
        for obj in MovieArray{
            let user = NSManagedObject(entity: userEntity, insertInto: managedContext)
            user.setValue(String(obj.id), forKey: "id")
            user.setValue(obj.title, forKey: "title")
            user.setValue(obj.overview, forKey: "overview")
            
            let url:String!
            if(obj.poster_path != nil)
            {
                url = API.IMAGE_BASE_URL + obj.poster_path
            }
            else
            {
                url = "https://image.tmdb.org/t/p/w185"
            }
            user.setValue(url, forKey: "poster_path")
            
        }
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func retrieveData() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        do {
            let result = try managedContext.fetch(fetchRequest)
            var arr = [[String:AnyObject]]()
            for data in result as! [NSManagedObject] {
                var obj = [String:AnyObject]()
                obj["id"] = data.value(forKey: "id") as AnyObject
                obj["title"] = data.value(forKey: "title") as AnyObject
                obj["overview"] = data.value(forKey: "overview") as AnyObject
                obj["poster_path"] = data.value(forKey: "poster_path") as AnyObject
                arr.append(obj)
            }
            MovieList = arr
            getModels()
            
        } catch {
            
            print("Failed")
        }
    }
    
    func deleteAllRecords() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Movie")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            self.createData()
        } catch {
            
        }
    }
    
    //MARK: - Display Alert -
    func displayAlert(_ title: String, andMessage message: String)
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = alertWindow.windowLevel + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            
        }))
        
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func displayAlertWithOneOptionAndAction(_ title: String, andMessage message: String , no noBlock:@escaping (() -> Void))
    {
        let alertWindow: UIWindow = UIWindow(frame: UIScreen.main.bounds)
        alertWindow.rootViewController = UIViewController()
        alertWindow.windowLevel = alertWindow.windowLevel + 1
        alertWindow.makeKeyAndVisible()
        
        let alertController: UIAlertController = UIAlertController(title: NSLocalizedString(title, comment: ""), message: NSLocalizedString(message, comment: ""), preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
            
            alertWindow.isHidden = true
            noBlock()
            
        }))
        alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
}
