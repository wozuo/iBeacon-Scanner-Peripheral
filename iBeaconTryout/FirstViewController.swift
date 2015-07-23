//
//  FirstViewController.swift
//  iBeaconTryout
//
//  Created by Marc Tarnutzer on 22/07/15.
//  Copyright (c) 2015 Marc Tarnutzer. All rights reserved.
//

import UIKit
import CoreLocation

class FirstViewController: UIViewController, CLLocationManagerDelegate, UITextViewDelegate {
    @IBOutlet weak var consoleView: UITextView!
    
    var region = CLBeaconRegion()
    var locationManager = CLLocationManager()
    let uuid = NSUUID(UUIDString: "CF943B10-3D35-41F1-A9BA-2B92F9B49569")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self;
        consoleView.delegate = self;
        
        //Request location services from user
        if (CLLocationManager.authorizationStatus() != CLAuthorizationStatus.AuthorizedAlways) {
            locationManager.requestAlwaysAuthorization()
        }
        
        region = CLBeaconRegion(proximityUUID: uuid, identifier: "Places")
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        locationManager.startUpdatingLocation()
        consoleView.insertText("\(getCurrentDate()) <C>: Start")
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //println(beacons)
        for beacon in beacons {
            consoleView.insertText("\n\(getCurrentDate()) <C>: ")
            let currentBeacon = beacon as! CLBeacon
            let minor = currentBeacon.minor.stringValue
            let major = currentBeacon.major.stringValue
            let consoleText = "-> Minor: \(minor) Major: \(major)"
            println("\(getCurrentDate()) \(consoleText)")
            consoleView.insertText(consoleText)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        let consoleText = "\n\(getCurrentDate()) <C>: Beacon is in range"
        sendLocalNotificationWithMessage(consoleText)
        consoleView.insertText(consoleText)
        println(consoleText)
        locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager!, didExitRegion region: CLRegion!) {
        locationManager.stopRangingBeaconsInRegion(region as! CLBeaconRegion)
        locationManager.stopUpdatingLocation()
        let consoleText = "\n\(getCurrentDate()) <C>: Beacon is out of range"
        sendLocalNotificationWithMessage(consoleText)
        consoleView.insertText(consoleText)
        println(consoleText)
    }
    
    func getCurrentDate() -> String {
        var todaysDate:NSDate = NSDate()
        var dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        var DateInFormat:String = dateFormatter.stringFromDate(todaysDate)
        return DateInFormat
    }
    
    func sendLocalNotificationWithMessage(message: String!) {
        let notification:UILocalNotification = UILocalNotification()
        notification.alertBody = message
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

