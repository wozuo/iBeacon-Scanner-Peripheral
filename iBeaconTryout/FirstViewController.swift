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
        //locationManager.startMonitoringForRegion(region)
        locationManager.startRangingBeaconsInRegion(region)
        consoleView.insertText(" <Console>: Start")
    }
    
    func locationManager(manager: CLLocationManager!, didRangeBeacons beacons: [AnyObject]!, inRegion region: CLBeaconRegion!) {
        //println(beacons)
        consoleView.insertText("\n <Console>: ")
        for beacon in beacons {
            let currentBeacon = beacon as! CLBeacon
            let minor = currentBeacon.minor.stringValue
            let major = currentBeacon.major.stringValue
            let consoleText = "-> Minor: \(minor) Major: \(major)"
            consoleView.insertText(consoleText)
        }
    }
    
    func locationManager(manager: CLLocationManager!, didEnterRegion region: CLRegion!) {
        self.locationManager.startRangingBeaconsInRegion(region as! CLBeaconRegion)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

