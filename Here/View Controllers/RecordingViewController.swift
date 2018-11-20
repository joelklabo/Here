//
//  RecordingViewController.swift
//  here
//
//  Created by Joel Klabo on 11/13/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class RecordingViewController: UIViewController {

    let audioRecorder = AudioRecorder()
    
    let actionButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let saveButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let deleteButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let cancelButton = UIButton(type: UIButton.ButtonType.roundedRect)
    
    let collapsedView = UIView()
    
    let topButtonSpacingView = UIView()
    
    let audioDisplayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collapsedView.backgroundColor = .red
        collapsedView.translatesAutoresizingMaskIntoConstraints = false
        
        topButtonSpacingView.backgroundColor = .blue
        
        audioDisplayView.backgroundColor = .red
        
        actionButton.setTitle("record", for: .normal)
        saveButton.setTitle("save", for: .normal)
        deleteButton.setTitle("delete", for: .normal)
        cancelButton.setTitle("cancel", for: .normal)
        
        let horizontalButtonStack = UIStackView(arrangedSubviews: [cancelButton, topButtonSpacingView, saveButton])
        horizontalButtonStack.axis = .horizontal
        horizontalButtonStack.distribution = .fillEqually
        
        let verticalStackView = UIStackView(arrangedSubviews: [horizontalButtonStack, audioDisplayView, actionButton])
        verticalStackView.axis = .vertical
        verticalStackView.distribution = .fillEqually
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(verticalStackView)
        
        view.addSubview(collapsedView)
        
        NSLayoutConstraint.activate([
            collapsedView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collapsedView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collapsedView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collapsedView.topAnchor.constraint(equalTo: view.topAnchor),
            verticalStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            verticalStackView.leftAnchor.constraint(equalTo: view.leftAnchor),
            verticalStackView.rightAnchor.constraint(equalTo: view.rightAnchor),
            verticalStackView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }

    func updateToExpandedState() {
        collapsedView.isHidden = true
    }
    
    func updateToCollapsedState() {
        collapsedView.isHidden = false
    }
}
