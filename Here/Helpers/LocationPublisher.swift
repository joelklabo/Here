//
//  LocationPublisher.swift
//  here
//
//  Created by Joel Klabo on 11/10/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import CoreLocation

fileprivate let locationUpdateNotificationName = Notification.Name("com.location.update")
fileprivate let locationUserInfoKey = "location"

class LocationPublisher: NSObject {
    
    static let shared = LocationPublisher()
    
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // check for Location Services
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
}

extension LocationPublisher: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else { return }
        let userInfo = [locationUserInfoKey: currentLocation]
        let updateNotification = Notification(name: locationUpdateNotificationName, object: nil, userInfo: userInfo)
        NotificationCenter.default.post(updateNotification)
    }
}

protocol LocationObserving: AnyObject {
    func update(location: CLLocation)
    func significantUpdate(location: CLLocation)
}

class LocationObserver: NSObject {
    private var previousSignificantLocation: CLLocation?
    private let significantDistance = CLLocationDistance(500)
    weak var delegate: LocationObserving?
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(LocationObserver.update(notification:)), name: locationUpdateNotificationName, object: nil)
    }
    @objc func update(notification: Notification) {
        if let location = notification.userInfo?[locationUserInfoKey] as? CLLocation {
            delegate?.update(location: location)
            
            if significantChangeOccurred(location: location) {
                previousSignificantLocation = location
                delegate?.significantUpdate(location: location)
            }
        }
    }
    
    private func significantChangeOccurred(location: CLLocation) -> Bool {
        guard let previous = previousSignificantLocation else {
            previousSignificantLocation = location
            return true
        }
        
        if previous.distance(from: location) > significantDistance {
            return true
        }
        
        return false
    }
}
