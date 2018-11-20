//
//  MainViewController.swift
//  here
//
//  Created by Joel Klabo on 11/10/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class MainViewController: UIViewController {
    
    let locationObserver = LocationObserver()
    
    let recordingViewController = RecordingViewController()
    let mapViewController = MapViewController()
    
    var recordingViewHeightConstraint: NSLayoutConstraint!
    var animator: UIViewPropertyAnimator!

    let expandedHeight: CGFloat = 400
    let collapsedHeight: CGFloat = 100
    
    let feedbackGenerator = UIImpactFeedbackGenerator()
    
    var isCollapsed: Bool {
        return recordingViewHeightConstraint.constant == collapsedHeight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let label = UILabel(frame: .zero)
        label.text = "here"
        label.font = UIFont.systemFont(ofSize: 30, weight: .heavy)
        label.sizeToFit()
        navigationItem.titleView = label
        
        addChild(mapViewController)
        view.addSubview(mapViewController.view)
        mapViewController.view.translatesAutoresizingMaskIntoConstraints = false
        mapViewController.didMove(toParent: self)
        
        addChild(recordingViewController)
        view.addSubview(recordingViewController.view)
        recordingViewController.view.translatesAutoresizingMaskIntoConstraints = false
        recordingViewController.didMove(toParent: self)
        
        recordingViewHeightConstraint = recordingViewController.view.heightAnchor.constraint(equalToConstant: 100)
        recordingViewHeightConstraint.isActive = true
        
        NSLayoutConstraint.activate([
            mapViewController.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapViewController.view.bottomAnchor.constraint(equalTo: recordingViewController.view.topAnchor),
            recordingViewController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            recordingViewController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            recordingViewController.view.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        recordingViewController.collapsedView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                          action: #selector(MainViewController.tappedRecordingView)))
        recordingViewController.cancelButton.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                                          action: #selector(MainViewController.tappedRecordingView)))
    }
    
    func updateToExpandedState() {
        recordingViewHeightConstraint.constant = self.expandedHeight
        mapViewController.updateToExpandedState()
        recordingViewController.updateToExpandedState()
    }
    
    func updateToCollapsedState() {
        recordingViewHeightConstraint.constant = self.collapsedHeight
        mapViewController.updateToCollapsedState()
        recordingViewController.updateToCollapsedState()
    }
    
    func animateViewUpdate() {
        feedbackGenerator.prepare()
        if self.isCollapsed {
            self.updateToExpandedState()
        } else {
            self.updateToCollapsedState()
        }
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        }) { _ in
            self.mapViewController.addPendingRecordingAnnotation()
            self.feedbackGenerator.impactOccurred()
        }
    }
    
    @objc func cancelRecording() {
        animateViewUpdate()
    }
    
    @objc func tappedRecordingView() {
        animateViewUpdate()
    }
    
}
