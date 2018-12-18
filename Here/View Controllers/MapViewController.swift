//
//  MapViewController.swift
//  here
//
//  Created by Joel Klabo on 11/18/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: BrandedViewController {

    let locationObserver = LocationObserver()
    
    let mapView = MKMapView()
    
    private var listenableRange: Double = 10
    private var normalRegionSize: Double = 30
    private var zoomRegionSize: Double = 20
    
    var currentLocation: CLLocation!
    
    var panningTimer: Timer?
    var annotationUpdateTimer: Timer?

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
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(userInteractedWithMap(recognizer:)))
        panGestureRecognizer.delegate = self
        
        let pinchGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(userInteractedWithMap(recognizer:)))
        pinchGestureRecognizer.delegate = self
        
        mapView.addGestureRecognizer(panGestureRecognizer)
        mapView.addGestureRecognizer(pinchGestureRecognizer)
        
        annotationUpdateTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            self.updateAnnotations()
        }
    }
    
    @objc func userInteractedWithMap(recognizer: UIGestureRecognizer) {
        mapShouldUpdate = false
        panningTimer?.invalidate()
        panningTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.mapShouldUpdate = true
        }
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
        mapView.showsUserLocation = false
        mapView.isUserInteractionEnabled = false
        centerMapToCurrentLocationHighZoom(location: currentLocation)
    }
    
    func updateToCollapsedState() {
        mapShouldUpdate = true
        mapView.showsUserLocation = true
        mapView.isUserInteractionEnabled = true
        centerMapToCurrentLocationNormalZoom(location: currentLocation)
    }
    
    func addAnnotationsForRecordings(_ recordings: [Recording]) {
        DispatchQueue.main.async {
            for recording in recordings {
                let annotation = RecordingAnnotation(recording, recording.location.coordinate)
                self.mapView.addAnnotation(annotation)
            }            
        }
    }
    
    func addPendingRecordingAnnotation() {
        let annotation = PendingRecordingAnnotation(currentLocation.coordinate)
        self.mapView.addAnnotation(annotation)
    }
}

extension MapViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MapViewController: MKMapViewDelegate {    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self)  { return nil }
        let annotationLocation = CLLocation(latitude: annotation.coordinate.latitude,
                                            longitude: annotation.coordinate.longitude)
        let distance = currentLocation.distance(from: annotationLocation)
        if distance < listenableRange {
            let annotationView = RecordingAnnotationView()
            annotationView.image = UIImage(named: "first")
            return annotationView
        } else {
            let annotationView = RecordingTooFarAnnotationView()
            annotationView.image = UIImage(named: "second")
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if view.isKind(of: RecordingTooFarAnnotationView.self) {
            StatusDisplayController.shared.alert(message: "Too Far Away")
            return
        }
        if let recordingAnnotation = view.annotation as? RecordingAnnotation {
            let recording = recordingAnnotation.recording
            let recordingViewController = RecorderViewController()
            recordingViewController.recording = recording
            present(recordingViewController, animated: true, completion: nil)
        }
    }
    
    private func updateAnnotations() {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(annotations)
    }
}

extension MapViewController: LocationObserving {
    func update(location: CLLocation) {
        if mapShouldUpdate {
            currentLocation = location
            centerMapToCurrentLocationNormalZoom(location: location)
        }
    }
    
    func significantUpdate(location: CLLocation) {
        StatusDisplayController.shared.show(message: "Loading...")
        DataService.queryRecordings(location) { result in
            switch result {
            case .success(let recordings):
                StatusDisplayController.shared.hide()
                self.addAnnotationsForRecordings(recordings)
            case .error(let error):
                print("Error: \(error)")
            }
        }
    }
}
