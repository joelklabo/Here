//
//  RecordingViewController.swift
//  here
//
//  Created by Joel Klabo on 11/13/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class OldRecordingViewController: UIViewController {

    let audioRecorder = AudioRecorder()
    
    var delegate: RecordingDelegate?
    
    let mapView = MKMapView()
    
    var location: CLLocation?
    
    let recordButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let saveButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let deleteButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let cancelButton = UIButton(type: UIButton.ButtonType.roundedRect)
    
    let audioDisplayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        audioRecorder.prepare()
        audioRecorder.delegate = self
        audioRecorder.intesityDelegate = self
        
        audioDisplayView.backgroundColor = .red
        
        recordButton.setTitle("record", for: .normal)
        recordButton.addTarget(self, action: #selector(recordButtonTapped(sender:)), for: .touchUpInside)
        saveButton.setTitle("save", for: .normal)
        saveButton.addTarget(self, action: #selector(saveButtonTapped(sender:)), for: .touchUpInside)
        deleteButton.setTitle("delete", for: .normal)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped(sender:)), for: .touchUpInside)
        cancelButton.setTitle("cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelButtonTapped(sender:)), for: .touchUpInside)
        
        let horizontalButtonStack = UIStackView(arrangedSubviews: [cancelButton, deleteButton, saveButton])
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.distribution = .fillEqually
        
        let verticalStackView = UIStackView(arrangedSubviews: [mapView, horizontalButtonStack, audioDisplayView, recordButton])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStackView)
        
        NSLayoutConstraint.activate([
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
        
        if let location = location {
            centerMapToCurrentLocationHighZoom(location: location)
        }
    }
    
    func centerMapToCurrentLocationHighZoom(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate,
                                        latitudinalMeters: 20,
                                        longitudinalMeters: 20)
        mapView.setRegion(region, animated: true)
    }
}

extension OldRecordingViewController {
    @objc func recordButtonTapped(sender: UIButton) {
        if audioRecorder.isRecording {
            recordButton.setTitle("record", for: .normal)
            audioRecorder.stop()
        } else {
            recordButton.setTitle("stop", for: .normal)
            audioRecorder.start()
        }
    }
    
    @objc func saveButtonTapped(sender: UIButton) {
        guard let fileURL = audioRecorder.fileURL() else { return }
        audioRecorder.stop()
        delegate?.saved(fileURL)
    }
    
    @objc func deleteButtonTapped(sender: UIButton) {
        audioRecorder.stop()
        audioRecorder.delete()
    }
    
    @objc func cancelButtonTapped(sender: UIButton) {
        audioRecorder.stop()
        audioRecorder.delete()
        delegate?.cancelled()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
}

extension OldRecordingViewController: AudioRecorderDelegate {
    func didFinishRecording() {
        audioRecorder.play()
    }
}

extension OldRecordingViewController: AudioIntesityLevelDelegate {
    func update(intensity: Float) {
        audioDisplayView.alpha = CGFloat(intensity)
    }
}
