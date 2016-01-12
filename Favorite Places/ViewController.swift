//
//  ViewController.swift
//  Favorite Places
//
//  Created by Aditya Vikram Godawat on 12/01/16.
//  Copyright © 2016 Wow Labz. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet var map: MKMapView!
    
    var manager: CLLocationManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        manager = CLLocationManager()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
        
        let uilpgr = UILongPressGestureRecognizer(target: self, action: "action:")
        uilpgr.minimumPressDuration = 1.5
        map.addGestureRecognizer(uilpgr)
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let userLocation:CLLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        let latDelta:CLLocationDegrees = 0.01
        let lonDelta:CLLocationDegrees = 0.01
        
        let coordinate:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let span:MKCoordinateSpan = MKCoordinateSpanMake(latDelta, lonDelta)
        let region:MKCoordinateRegion = MKCoordinateRegionMake(coordinate, span)
        
        self.map.setRegion(region, animated: true)
    }
    
    func action(gestureRecognizer:UIGestureRecognizer) {
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            
            let touchPoint = gestureRecognizer.locationInView(self.map)
            let newCoordinate = map.convertPoint(touchPoint, toCoordinateFromView: self.map)
            let location = CLLocation(latitude: newCoordinate.latitude, longitude: newCoordinate.longitude)
            
            var title1 = ""
            
            CLGeocoder().reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
                
                if (error == nil) {
                    
                    if let p = placemarks?.first {
                        
                        var subThoroughfare:String = ""
                        var throughfare:String = ""
                        
                        if p.subThoroughfare != nil {
                            subThoroughfare = p.subThoroughfare!
                        }
                       
                        if p.thoroughfare != nil {
                            throughfare = p.thoroughfare!
                        }
                        
                        title1 = "\(subThoroughfare) \(throughfare)"
                        print(title1)
                        
                    }
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = newCoordinate
                    annotation.title = title1
                    self.map.addAnnotation(annotation)
                }
                
                if title1 == "" {
                    
                    title1 = "Added\(NSDate())"
                    print(title1)
                    
                }
                
            })
            
        }
        
    }
}

