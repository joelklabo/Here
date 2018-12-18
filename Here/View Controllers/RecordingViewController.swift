//
//  RecordingViewController.swift
//  Here
//
//  Created by Joel Klabo on 12/4/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class RecordingViewController: BrandedViewController {
    
    enum State {
        case start
        case recording
        case playing
        case saving
    }
    
    var state: State = .start {
        didSet {
            stateUpdate()
        }
    }
    
    // MARK: TEST STUFF

    var timer: Timer?
    
    // MARK: TEST STUFF
    
    var location: CLLocation?
    
    private let mapView = MKMapView()
    private let timeView = TimeView()
    private let recordButton = RecordButton()
    private let deleteButton = DeleteButton()
    
    private var saveButton: UIBarButtonItem!
    private var cancelButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(save))
        cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancel))

        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = saveButton
        
        view.backgroundColor = .white
        
        let actionBarStackView = UIStackView()
        actionBarStackView.axis = .horizontal
        actionBarStackView.distribution = .fillEqually
        actionBarStackView.addArrangedSubview(UIView())
        actionBarStackView.addArrangedSubview(recordButton)
        actionBarStackView.addArrangedSubview(deleteButton)

        let controlsStackView = UIStackView()
        controlsStackView.axis = .vertical
        controlsStackView.distribution = .fillProportionally
        controlsStackView.spacing = 50
        controlsStackView.addArrangedSubview(UIView())
        controlsStackView.addArrangedSubview(timeView)
        controlsStackView.addArrangedSubview(actionBarStackView)
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.distribution = .fillEqually
        mainStackView.addArrangedSubview(mapView)
        mainStackView.addArrangedSubview(controlsStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(mainStackView)
        
        let guide = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            mainStackView.leftAnchor.constraint(equalTo: guide.leftAnchor),
            mainStackView.topAnchor.constraint(equalTo: guide.topAnchor),
            mainStackView.rightAnchor.constraint(equalTo: guide.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
        recordButton.addTarget(self, action: #selector(record), for: .record)
        recordButton.addTarget(self, action: #selector(stop), for: .stop)
        
        deleteButton.addTarget(self, action: #selector(delete(sender:)), for: .delete)
        
        centerOnLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: State Changes

extension RecordingViewController {
    private func stateUpdate() {
        switch state {
        case .start:
            recordButton.isEnabled = true
            deleteButton.isEnabled = false
            saveButton.isEnabled = false
            cancelButton.isEnabled = true
        case .recording:
            recordButton.isEnabled = true
            deleteButton.isEnabled = false
            saveButton.isEnabled = false
            cancelButton.isEnabled = true
        case .playing:
            // Actually play
            recordButton.isEnabled = false
            deleteButton.isEnabled = true
            saveButton.isEnabled = true
            cancelButton.isEnabled = true
        case .saving:
            recordButton.isEnabled = false
            deleteButton.isEnabled = false
            saveButton.isEnabled = false
            cancelButton.isEnabled = false
        }
    }
}

// MARK: Map

extension RecordingViewController {
    
    private func centerOnLocation() {
        guard let location = location else { return }
        
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
        annotation.title = "You"
        return annotation
    }
    
    private func region(forLocation location: CLLocation) -> MKCoordinateRegion {
        let metersWide: CLLocationDistance = 50
        let coordinate = location.coordinate
        return MKCoordinateRegion(center: coordinate, latitudinalMeters: metersWide, longitudinalMeters: metersWide)
    }
}

// MARK: Navigation Item Actions

extension RecordingViewController {
    @objc private func save() {
        print("save")
    }
    @objc private func cancel() {
        print("cancel")
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

// MARK: Record Button Actions

extension RecordingViewController {
    @objc private func record() {
        state = .recording
        timeView.samples = []
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            self.timeView.samples.append(CGFloat.random(in: 0.2...1))
        }
    }
    @objc private func stop() {
        state = .playing
        timer?.invalidate()
    }
    @objc private func delete(sender: DeleteButton) {
        state = .start
        timeView.samples = []
    }
}
