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
    
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
       
        func getAPI(completion: @escaping (_ result: [CLLocationCoordinate2D]) -> Void){
            
            let origin = "43.66183610,-79.3545239"
            let destination = "43.76801790,-79.32927280"
            Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", method:.get, parameters:["origin":origin,"destination":destination,"key":"AIzaSyCvS76QKyVHb4zpMyLjNLSNSoTgkkQvULI"])
                .responseJSON { response in
                    if let jsonValue = response.result.value {
                        let json = JSON(jsonValue)
                        let total = json["routes"][0]["legs"][0]["steps"]
                        let num = total.count
                        for i in 1...num {
                            let data = total[i]["end_location"]
                            //                        print(data)
                            guard let lat = data["lat"].double else {return}
                            guard let lng = data["lng"].double else {return}
                            //                        print(lat)
                            let item = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                            self.collection.append(item)
                            print(self.collection)
                            completion(self.collection)
                      
                            
                        }
                        
                    }
            }.resume()
        }
        
        
        func completionFunction(_ result: [CLLocationCoordinate2D]) -> Void {
            self.mapView.delegate = self
            print(result)
            //            print(collection[1])
            let sourceCoordinate = collection[0]
            //            let secondCoordiante = collection[1]
            let secondCoordiante = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
            //        let thirdCoordinate = collection[2]
            let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
            let secondPlacemark = MKPlacemark(coordinate: secondCoordiante, addressDictionary: nil)
            let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
            let secondMapItem = MKMapItem(placemark: secondPlacemark)
            let sourceAnnotation = MKPointAnnotation()
            sourceAnnotation.title = "Times Square"
            if let location = sourcePlacemark.location {
                sourceAnnotation.coordinate = location.coordinate
            }
            let destinationAnnotation = MKPointAnnotation()
            destinationAnnotation.title = "Empire State Building"
            
            if let location = secondPlacemark.location {
                destinationAnnotation.coordinate = location.coordinate
            }
            self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
            let directionRequest = MKDirectionsRequest()
            directionRequest.source = sourceMapItem
            directionRequest.destination = secondMapItem
            directionRequest.transportType = .automobile
            // Calculate the direction
            let directions = MKDirections(request: directionRequest)
            directions.calculate {
                (response, error) -> Void in
                
                guard let response = response else {
                    if let error = error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                let route = response.routes[0]
                self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
                
                let rect = route.polyline.boundingMapRect
                self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
            }
        }
        
        getAPI(completion: completionFunction(_:))
    }

        
    
//        let sourceCoordinate = CLLocationCoordinate2D(latitude: 40.759011, longitude: -73.984472)
//        let secondCoordiante = CLLocationCoordinate2D(latitude: 40.748441, longitude: -73.985564)
////        let thirdCoordinate = collection[2]
//        let sourcePlacemark = MKPlacemark(coordinate: sourceCoordinate, addressDictionary: nil)
//        let secondPlacemark = MKPlacemark(coordinate: secondCoordiante, addressDictionary: nil)
//        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
//        let secondMapItem = MKMapItem(placemark: secondPlacemark)
//        let sourceAnnotation = MKPointAnnotation()
//        sourceAnnotation.title = "Times Square"
//        if let location = sourcePlacemark.location {
//            sourceAnnotation.coordinate = location.coordinate
//        }
//        let destinationAnnotation = MKPointAnnotation()
//        destinationAnnotation.title = "Empire State Building"
//
//        if let location = secondPlacemark.location {
//            destinationAnnotation.coordinate = location.coordinate
//        }
//        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
//        let directionRequest = MKDirectionsRequest()
//        directionRequest.source = sourceMapItem
//        directionRequest.destination = secondMapItem
//        directionRequest.transportType = .automobile
//        // Calculate the direction
//        let directions = MKDirections(request: directionRequest)
//        directions.calculate {
//            (response, error) -> Void in
//
//            guard let response = response else {
//                if let error = error {
//                    print("Error: \(error)")
//                }
//                return
//            }
//
//            let route = response.routes[0]
//            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
//
//            let rect = route.polyline.boundingMapRect
//            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
//        }
//
//
//    }
//
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.red
        renderer.lineWidth = 4.0
        
        return renderer
    }

//    func getAPI(){
//        let origin = "43.66183610,-79.3545239"
//        let destination = "43.76801790,-79.32927280"
//        Alamofire.request("https://maps.googleapis.com/maps/api/directions/json", method:.get, parameters:["origin":origin,"destination":destination,"key":"AIzaSyCvS76QKyVHb4zpMyLjNLSNSoTgkkQvULI"])
//            .responseJSON { response in
//                if let jsonValue = response.result.value {
//                    let json = JSON(jsonValue)
//                    let total = json["routes"][0]["legs"][0]["steps"]
//                        let num = total.count
//                    for i in 1...num {
//                        let data = total[i]["end_location"]
////                        print(data)
//                        guard let lat = data["lat"].double else {return}
//                        guard let lng = data["lng"].double else {return}
////                        print(lat)
//                        let item = CLLocationCoordinate2D(latitude: lat, longitude: lng)
//                        self.collection.append(item)
//                        print(self.collection)
//
//
//                    }
//
//                }
//            }
//     }
    
    
}
