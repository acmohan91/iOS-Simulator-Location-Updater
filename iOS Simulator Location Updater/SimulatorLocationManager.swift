//
//  SimulatorLocationManager.swift
//  iOS Simulator Location Updater
//
//  Created by Francesco Perrotti-Garcia on 2/1/15.
//  Copyright (c) 2015 Francesco Perrotti-Garcia. All rights reserved.
//

import Cocoa
import CoreLocation

private let _SimulatorLocationManagerInstance = SimulatorLocationManager()

class SimulatorLocationManager: NSObject {
    
    class var sharedInstance: SimulatorLocationManager {
        return _SimulatorLocationManagerInstance
    }
    
    func updateSimulatorLocation(newLocation location: CLLocation) {
        println("Updating simulator location to \(location.coordinate.latitude), \(location.coordinate.longitude)")
        
        var returnDescriptor: NSAppleEventDescriptor? = nil
        
        let script =    "tell application \"iOS Simulator\"\nactivate\nend tell\n\ntell application \"System Events\"\ntell process \"iOS Simulator\"\ntell menu bar 1\ntell menu bar item \"Debug\"\ntell menu \"Debug\"\ntell menu item \"Location\"\nclick\ntell menu \"Location\"\nclick menu item \"Custom Location…\"\nend tell\nend tell\nend tell\n                           end tell\nend tell\n\ntell window 1\nset value of text field 1 to \"\(location.coordinate.latitude)\"\nset value of text field 2 to \"\(location.coordinate.longitude)\"\nclick button \"OK\"\nend tell\n\nend tell\nend tell\n"
        
        /*
        tell application "iOS Simulator"
            activate
        end tell
        
        tell application "System Events"
            tell process "iOS Simulator"
                tell menu bar 1
                    tell menu bar item "Debug"
                        tell menu "Debug"
                            tell menu item "Location"
                                click
                                tell menu "Location"
                                    click menu item "Custom Location…"
                                end tell
                            end tell
                        end tell
                    end tell
                end tell
                    
                tell window 1
                    set value of text field 1 to \(location.coordinate.latitude)
                    set value of text field 2 to \(location.coordinate.longitude)
                    click button "OK"
                end tell
            
            end tell
        end tell
        */
        //The script above was heavily inspired in this SO answer: http://stackoverflow.com/a/24376542/2305521

        let scriptObject = NSAppleScript(source: script)!
        
        var errorDict: NSDictionary? = nil

        scriptObject.compileAndReturnError(&errorDict)
        println(errorDict)
        scriptObject.executeAndReturnError(&errorDict)
        
        if errorDict != nil {
            println("Location set successfully")
        }
        else {
            println("Error setting location")
        }
    }
}
