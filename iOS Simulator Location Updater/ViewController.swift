//
//  ViewController.swift
//  iOS Simulator Location Updater
//
//  Created by Francesco Perrotti-Garcia on 2/1/15.
//  Copyright (c) 2015 Francesco Perrotti-Garcia. All rights reserved.
//

import Cocoa
import CoreLocation

struct Constants {
    struct UserDefaultsKey {
        static let kMinimumDistance = "minimumDistance"
    }
}


class ViewController: NSViewController, CLLocationManagerDelegate, NSTextFieldDelegate {

    @IBOutlet weak var minimumDistanceField: NSTextField!
    @IBOutlet weak var button: NSButton!

    var isMonitoring = false
    var titleForState = [false : "Start Monitoring", true : "Stop Monitoring"]
    
    var locationManager = CLLocationManager()
    
    var distanceThreshold : Double {
        get {
            if NSUserDefaults.standardUserDefaults().valueForKey(Constants.UserDefaultsKey.kMinimumDistance) == nil {
                NSUserDefaults.standardUserDefaults().setDouble(2.0, forKey: Constants.UserDefaultsKey.kMinimumDistance)
            }
            return NSUserDefaults.standardUserDefaults().valueForKey(Constants.UserDefaultsKey.kMinimumDistance) as Double!
        }
        set {
            NSUserDefaults.standardUserDefaults().setDouble(newValue, forKey: Constants.UserDefaultsKey.kMinimumDistance)
            updateDistance()
        }
    }
    // TODO: Figure out a better place to put this

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        
        updateDistance()
        updateUI()
    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    // MARK: Actions
    @IBAction func didClickButton(sender: NSButton) {
        isMonitoring = !isMonitoring
        updateMonitoringStatus()
        updateUI()
    }
    
    @IBAction func forceUpdate(sender: NSButton) {
        locationManager.stopUpdatingLocation()
        locationManager.startUpdatingLocation()
//        SimulatorLocationManager.sharedInstance.updateSimulatorLocation(newLocation: locationManager.location)
    }
    
    // MARK: Updaters
    func updateUI() {
        button.title = titleForState[isMonitoring]!
        minimumDistanceField.doubleValue = distanceThreshold
    }
    
    func updateMonitoringStatus() {
        if isMonitoring {
            locationManager.startUpdatingLocation()
        }
        else {
            locationManager .stopUpdatingLocation()
        }
        
    }
    
    func updateDistance() {
        locationManager.distanceFilter = distanceThreshold
    }
    
    // MARK: CLLocationDelegate
    func locationManager(manager: CLLocationManager!, didUpdateToLocation newLocation: CLLocation!, fromLocation oldLocation: CLLocation!) {
        let locationDistance = oldLocation?.distanceFromLocation(newLocation)
        SimulatorLocationManager.sharedInstance.updateSimulatorLocation(newLocation: newLocation)
        println("Distance: \(locationDistance) meters")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println(error)
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
            case .Authorized:
                println("Authorized")
                updateMonitoringStatus()
            case .Denied:
                println("Denied")
            case .NotDetermined:
                println("Not determined") //Trigger ask for permission
                locationManager.startUpdatingLocation()
                locationManager.stopUpdatingLocation()
            case .Restricted:
                println("Restricted")
        }
    }
    
    // MARK: NSTextFieldDelegate
    override func controlTextDidChange(obj: NSNotification) {
        if obj.object as NSTextField == minimumDistanceField {
            distanceThreshold = minimumDistanceField.doubleValue
        }
    }

}

