//
//  LocationViewController.swift
//  here
//
//  Created by Joel Klabo on 7/13/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class LocationViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    let location: CLLocation
    
    init(withLocation location: CLLocation) {
        self.location = location
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupMap(forLocation: location)
    }
    
    private func setupMap(forLocation location: CLLocation) {
        // Set Region
        let mapRegion = region(forLocation: location)
        mapView.setRegion(mapRegion, animated: true)
        
        // Set Annotation
        let annotation = mapAnnotation(forLocation: location)
        mapView.addAnnotation(annotation)
    }
    
    private func mapAnnotation(forLocation location: CLLocation) -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        let centerCoordinate = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        annotation.coordinate = centerCoordinate
        annotation.title = "Your Recording"
        return annotation
    }
    
    private func region(forLocation location: CLLocation) -> MKCoordinateRegion {
        let metersWide: CLLocationDistance = 50
        let coordinate = location.coordinate
        return MKCoordinateRegion(center: coordinate, latitudinalMeters: metersWide, longitudinalMeters: metersWide)
    }
}
