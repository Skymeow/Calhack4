//
//  ARView.swift
//  Calhack
//
//  Created by Sky Xu on 10/7/17.
//  Copyright © 2017 Sky Xu. All rights reserved.
//

import UIKit

//class ARView: ARSCNView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

//}

//func getElevation(){
//    for i in 0..<(self.location).count{
//        let itemLocation = self.location[i]
//        print(itemLocation)
//        Alamofire.request("https://maps.googleapis.com/maps/api/elevation/json", method:.get, parameters:["locations":itemLocation,"key":"AIzaSyAFTXqvig91nFf_imYYtAbgtVhfc4CEiSY"])
//            .responseJSON { response in
//                print("got a callback")
//                if let jsonValue = response.result.value {
//                    print("got a response")
//                    let json = JSON(jsonValue)
//                    let elevation = json["results"][0]["elevation"]
//                    print(elevation)
//                    let item = elevation.double
//                    print(item)
//                    self.elevationData.append(item!)
//                    print(self.elevationData)
//                    completionElevationFunction()
//                    
//                }
//            }.resume()
//    }
//}


//
//func completionElevationFunction() -> Void {
//    //            self.mapView.delegate = self
//    getElevation()
//}

