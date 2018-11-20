//
//  MapViewController.swift
//  here
//
//  Created by Joel Klabo on 11/18/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {

    let locationObserver = LocationObserver()
    
    let mapView = MKMapView()
    
    private var normalRegionSize: Double = 250
    private var zoomRegionSize: Double = 50
    
    var currentLocation: CLLocation!
    
    var mapShouldUpdate = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mapView)
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        locationObserver.delegate = self
    }
    
    func centerMapToCurrentLocationNormalZoom(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: normalRegionSize,
                                        longitudinalMeters: normalRegionSize)
        mapView.setRegion(region, animated: true)
    }
    
    func centerMapToCurrentLocationHighZoom(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: zoomRegionSize,
                                        longitudinalMeters: zoomRegionSize)
        mapView.setRegion(region, animated: true)
    }
    
    func updateToExpandedState() {
        mapShouldUpdate = false
        mapView.showsUserLocation = true
        centerMapToCurrentLocationHighZoom(location: currentLocation)
    }
    
    func updateToCollapsedState() {
        mapShouldUpdate = true
        mapView.showsUserLocation = true
        centerMapToCurrentLocationNormalZoom(location: currentLocation)
    }
    
    func addPendingRecordingAnnotation() {
        let annotation = PendingRecordingAnnotation(currentLocation.coordinate)
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "PendingRecordingAnnotationView")
        
        if annotationView == nil { annotationView = RecordingAnnotationView() }
        
        if annotation.isKind(of: MKUserLocation.self)  { return nil }
        
        annotationView?.image = UIImage(named: "cassette")
        
        return annotationView
    }
}

extension MapViewController: LocationObserving {
    func update(location: CLLocation) {
        if mapShouldUpdate {
            currentLocation = location
            centerMapToCurrentLocationNormalZoom(location: location)
        }
    }
}
