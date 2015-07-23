//
//  SecondViewController.swift
//  iBeaconTryout
//
//  Created by Marc Tarnutzer on 22/07/15.
//  Copyright (c) 2015 Marc Tarnutzer. All rights reserved.
//

import UIKit
import CoreLocation
import CoreBluetooth

class SecondViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate {
    @IBOutlet weak var consoleView: UITextView!
    
    let major: CLBeaconMajorValue = 1
    let minor: CLBeaconMinorValue = 2
    let uuid: NSUUID! = NSUUID(UUIDString: "CF943B10-3D35-41F1-A9BA-2B92F9B49569")
    let identifier: String! = "Places"
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()
    var region = CLBeaconRegion()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        peripheralManager.delegate = self
        consoleView.delegate = self

        region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
        advertisedData = region.peripheralDataWithMeasuredPower(nil)
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
        consoleView.insertText("<Console>: Start")
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
            consoleView.insertText("\n<Console>: Advertising... ")
        default:
            println("default")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

