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
    
    var delegate: RecordingDelegate?
    
    let recordButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let saveButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let deleteButton = UIButton(type: UIButton.ButtonType.roundedRect)
    let cancelButton = UIButton(type: UIButton.ButtonType.roundedRect)
    
    let collapsedView = UIView()
    
    let audioDisplayView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioRecorder.prepare()
        audioRecorder.delegate = self
        audioRecorder.intesityDelegate = self
        
        collapsedView.backgroundColor = .green
        collapsedView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        let verticalStackView = UIStackView(arrangedSubviews: [horizontalButtonStack, audioDisplayView, recordButton])
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

extension RecordingViewController {
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
    }
}

extension RecordingViewController: AudioRecorderDelegate {
    func didFinishRecording() {
        audioRecorder.play()
    }
}

extension RecordingViewController: AudioIntesityLevelDelegate {
    func update(intensity: Float) {
        audioDisplayView.alpha = CGFloat(intensity)
    }
}
