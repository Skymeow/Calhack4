//
//  ViewController.swift
//  Calhack
//
//  Created by Sky Xu on 10/7/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit
import Alamofire
import SwiftyJSON
class ViewController: UIViewController, MKMapViewDelegate {
    var collection = [CLLocationCoordinate2D]()
    var location = [String]()
    var elevationData = [Double]()
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        func getAPI(){
            let origin = "37.866629, -122.260221"
            let destination = "37.866173, -122.253907"
            Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", method:.get, parameters:["origin":origin,"destination":destination,"key":"AIzaSyD5PymUhZ6yYARnmzAdk7omFRuCKzV3kSE"])
                .responseJSON { response in
                    print("got a callback")
                    if let jsonValue = response.result.value {
                        print("got a response")
                        let json = JSON(jsonValue)
                        let total = json["routes"][0]["legs"][0]["steps"]
                        let num = total.count
                        print("got \(num) data points")
                        for i in 0..<num {
                            let data = total[i]["end_location"]
                            //                        print(data)
                            guard let lat = data["lat"].double else {return}
                            guard let lng = data["lng"].double else {return}
                            self.location.append("\(lat),\(lng)")
                            print(self.location)
                            let item = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            self.collection.append(item)
                        }
                        print("calling the completion funtcion")
                        completionFunction()

                    }
            }.resume()
        }
        
        let myGroup = DispatchGroup()
        func getElevation(){
            for i in 0..<(self.location).count{
                myGroup.enter()
                let itemLocation = self.location[i]
                print(itemLocation)
                Alamofire.request("https://maps.googleapis.com/maps/api/elevation/json", method:.get, parameters:["locations":itemLocation,"key":"AIzaSyDxyFhJs9xKf0nT4wFrmfoCecHDLtjAjLU"])
                    .responseJSON { response in
                        print("got a callback")
                        if let jsonValue = response.result.value {
                            print("got a response")
                            let json = JSON(jsonValue)
                            let elevation = json["results"][0]["elevation"]
                            let item = elevation.double
                            self.elevationData.append(item!)
//                            print(self.elevationData)
                            myGroup.leave()
                        }
                    }
             }
            myGroup.notify(queue: .main) {
                print("Finished all requests.")
                print(self.elevationData)
                
            }
         }
        
        
        func completionFunction() -> Void {
//            self.mapView.delegate = self
            print(collection)
            print(location)
            getElevation()

        }
        
        getAPI()
 
     }
//    this is inside viewdidload
    
}
