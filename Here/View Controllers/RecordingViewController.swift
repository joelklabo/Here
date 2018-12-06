//
//  RecordingViewController.swift
//  Here
//
//  Created by Joel Klabo on 12/4/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class RecordingViewController: UIViewController {
    
    // MARK: TEST STUFF

    var timer: Timer?
    
    // MARK: TEST STUFF
    
    var location: CLLocation?
    
    private let mapView = MKMapView()
    private let timeView = TimeView()
    private let recordButton = RecordButton()
    private let deleteButton = DeleteButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
}

// MARK: Record Button Actions

extension RecordingViewController {
    @objc private func record() {
        print("RECORD")
        timeView.samples = []
        timer = Timer.scheduledTimer(withTimeInterval: 0.02, repeats: true) { _ in
            self.timeView.samples.append(CGFloat.random(in: 0...1))
        }
    }
    @objc private func stop() {
        print("STOP")
        timer?.invalidate()
    }
    @objc private func delete(sender: DeleteButton) {
        print("DELETE")
    }
}
