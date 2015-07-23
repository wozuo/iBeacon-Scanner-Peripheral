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

class SecondViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var consoleView: UITextView!
    @IBOutlet weak var broadcastSwitch: UISwitch!
    @IBOutlet weak var majorTextField: UITextField!
    @IBOutlet weak var minorTextField: UITextField!

    let uuid: NSUUID! = NSUUID(UUIDString: "CF943B10-3D35-41F1-A9BA-2B92F9B49569")
    let identifier: String! = "Places"
    var peripheralManager = CBPeripheralManager()
    var advertisedData = NSDictionary()
    var region = CLBeaconRegion()
    var minor: CLBeaconMinorValue = 0
    var major: CLBeaconMajorValue = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        broadcastSwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
        peripheralManager.delegate = self
        consoleView.delegate = self
        majorTextField.delegate = self
        minorTextField.delegate = self
        
        minorTextField.text = "\(minor)"
        majorTextField.text = "\(major)"
        
        consoleView.insertText("<Console>: Type in minor and major value and flip the switch to start advertising")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager!) {
        switch peripheral.state {
        case CBPeripheralManagerState.PoweredOn:
            self.peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
            consoleView.insertText("\n<Console>: Advertising... ")
        case CBPeripheralManagerState.PoweredOff:
            consoleView.insertText("\n<Console>: Bluetooth Status: Turned Off")
            
        case CBPeripheralManagerState.Resetting:
            consoleView.insertText("\n<Console>: Bluetooth Status: Resetting")
            
        case CBPeripheralManagerState.Unauthorized:
            consoleView.insertText("\n<Console>: Bluetooth Status: Not Authorized")
            
        case CBPeripheralManagerState.Unsupported:
            consoleView.insertText("\n<Console>: Bluetooth Status: Not Supported")
            
        default:
            consoleView.insertText("\n<Console>: Bluetooth Status: Unknown")
        }
    }
    
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            consoleView.insertText("\n<Console>: Advertising mode: ON")
            minor = CLBeaconMinorValue(minorTextField.text.toInt()!)
            major = CLBeaconMajorValue(majorTextField.text.toInt()!)
            region = CLBeaconRegion(proximityUUID: uuid, major: major, minor: minor, identifier: identifier)
            advertisedData = region.peripheralDataWithMeasuredPower(nil)
            peripheralManager = CBPeripheralManager(delegate: self, queue: nil, options: nil)
            peripheralManager.startAdvertising(advertisedData as [NSObject : AnyObject])
            consoleView.insertText("\n<Console>: Start advertising with UUID: \(uuid.UUIDString) minor: \(minor) , major: \(major)")
        } else {
            consoleView.insertText("\n<Console>: Advertising mode: OFF")
            peripheralManager.stopAdvertising()
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {   //delegate method
        textField.resignFirstResponder()
        return true
    }
}

