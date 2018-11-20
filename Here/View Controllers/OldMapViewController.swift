//
//  MapViewController.swift
//  here
//
//  Created by Joel Klabo on 6/25/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class OldMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, ViewControllerDismissing {

    var locationManager: CLLocationManager!
    var location: CLLocation!
    
    private var shownAnnotations = false
    
    private var regionSize: Double = 250
    
    private let recordingSegueIdentifier = "prepareForRecordingController"
    
    @IBOutlet var mapView: MKMapView!
    
    // MARK - View Controller Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
        // observe Notificatoins
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.addDidEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        // setup Location Services
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        // check for Location Services
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    
    @objc func addDidEnterForeground() {
        // reload Annotations
        shownAnnotations = false
    }
    
    // MARK - Actions
    
    @IBAction func tappedRecord(_ sender: Any) {
        let recordLocationViewController = RecordingLocationViewController(withLocation: location)
        recordLocationViewController.delegate = self
        present(recordLocationViewController, animated: true, completion: nil)
    }
    
    @IBAction func tappedRecenter(_ sender: Any) {
        centerMapToCurrentLocation()
    }
    
    // MARK - Map Helpers
    
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotationsForRecordings(_ recordings: [Recording]) {
        for recording in recordings {
            let annotation = RecordingAnnotation(recording, recording.location.coordinate)
            self.mapView.addAnnotation(annotation)
        }
    }
    
    func centerMapToCurrentLocation() {
        mapView.setRegion(currentRegion(), animated: true)
    }
    
    func currentRegion() -> MKCoordinateRegion {
        return MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionSize, longitudinalMeters: regionSize)
    }
    
    // MARK - MKMapViewDelegate
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "RecordingAnnotationView")
        
        if annotationView == nil {
            annotationView = RecordingAnnotationView()
        }
        
        if annotation.isKind(of: MKUserLocation.self)  {
            return nil
        }
        
        annotationView?.image = UIImage(named: "cassette")
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let recordingAnnotation = view.annotation as? RecordingAnnotation {
            let recording = recordingAnnotation.recording
            let recordLocationViewController = RecordingLocationViewController(withRecording: recording)
            recordLocationViewController.delegate = self
            present(recordLocationViewController, animated: true, completion: nil)
        }
    }
    
    // MARK - CLLocationManagerDelegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.first else {
            return
        }
        
        location = currentLocation
        
        if !shownAnnotations {
            centerMapToCurrentLocation()
            DataService.queryRecordings(location) { result in
                switch result {
                case .success(let recordings):
                    self.addAnnotationsForRecordings(recordings)
                case .error(let error):
                    print("Error: \(error)")
                }
            }
            shownAnnotations = true
        }
    }
    
    //MARK: Recorder Delegate
    
    func recordingCancelled() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func recordingSaved(_ recording: Recording) {
        print(recording)
        self.dismiss(animated: true) {
            self.shownAnnotations = false
        }
    }
    
    // MARK: RecordingLocationViewControllerDelegate
    
    func dismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func saved(_ recording: Recording) {
        print(recording)
        self.dismiss(animated: true) {
            self.shownAnnotations = false
        }
    }
}
