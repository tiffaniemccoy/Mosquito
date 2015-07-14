//
//  ViewController.swift
//  Mosquito
//
//  Created by Tiffanie McCoy on 7/6/15.
//  Copyright (c) 2015 Citizen Science. All rights reserved.
//

import UIKit
import CoreLocation
import Foundation
import Alamofire

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        println("inside didChangeAuthorizationStatus")
        if status == .AuthorizedAlways || status == .AuthorizedWhenInUse {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        println("inside didUpdateLocations")
        //grab the location and do something with it
        var latestLocation = locations.last
        let coords = latestLocation!.coordinate
        println("coords: " + coords.latitude.description)
        
        //stop the location service?
        locationManager.stopUpdatingLocation()
        
        //update the database
        sendDatatoServer("-666.666666", latitude: "66.666666", date: "2015-07-04" )
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error while updating location: " + error.localizedDescription)
    }
    
    @IBAction func findMyLocation(sender:AnyObject) {
        println("inside findMyLocation")
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    //TODO: add extra code for iOS 7 support
    
    // send the longitude, latitude, and date to the database server
    func sendDatatoServer(longitude: String!, latitude: String!, date: String!) {
        
        println("inside sendDataToServer")
        
        Alamofire.request(.POST, "http://10.0.2.2/index.php", parameters:["latitude": latitude, "longitude": longitude, "date": date])
            .responseString { (_, _, string, _) in
                println(string)
                
        }
        
        /*
        let request = NSMutableURLRequest(URL: NSURL(string: "http://10.0.2.2/index.php")!)
        request.HTTPMethod = "POST"
        
        let postString = "longitude=" + longitude + "&latitude=" + latitude + "&date=" + date
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                println("error=\(error)")
                return
            }
            
            println("response = \(response)")
            
            let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
            println("responseString = \(responseString)")
        }
        task.resume()
*/
    }

}

