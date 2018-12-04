//
//  RecorderViewController.swift
//  here
//
//  Created by Joel Klabo on 7/12/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit

class RecorderViewController: UIViewController {
    
    enum State {
        case record
        case stop
        case play
    }
    
    var audioRecorder = AudioRecorder()
    
    var delegate: (RecordingDelegate & ViewControllerDismissing)?
    
    var recording: Recording?
    
    @IBOutlet weak var actionButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var exitButton: UIButton!
    
    private var state: State = .record {
        didSet {
            update(for: state)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let recording = recording {
            audioRecorder.audioFileURL = recording.fileURL
            state = .play
        } else {
            state = .record
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideSaveAndDelete()
    }
    
    // MARK - View State
    
    private func update(for state: State) {
        switch state {
        case .record:
            // Hide delete and save buttons
            hideSaveAndDelete()
            // button type is record
            actionButton.setTitle("record", for: .normal)
        case .stop:
            // Hide delete and save buttons
            hideSaveAndDelete()
            // button type is stop
            actionButton.setTitle("stop", for: .normal)
        case .play:
            // if this is create mode, show delete and save buttons
            if let _ = recording {
                hideSaveAndDelete()
            } else {
                showSaveAndDelete()
            }
            // button type is play
            actionButton.setTitle("play", for: .normal)
        }
    }
    
    private func hideSaveAndDelete() {
        saveButton.isHidden = true
        deleteButton.isHidden = true
    }
    
    private func showSaveAndDelete() {
        saveButton.isHidden = false
        deleteButton.isHidden = false
    }

    // MARK - Actions
    
    @IBAction func actionButtonTapped(_ sender: Any) {
        // Initial state: Record
        // TAP
        // Change to state: Stop Recording
        // TAP
        // Change to state: Play (Delete or Accept show up now)
        // TAP Delete OR Accept and we go back to initial state
        // TAP Play and we play again
        switch state {
        case .record:
            // Begin recording here
            audioRecorder.start()
            state = .stop
        case .stop:
            // End recording here
            audioRecorder.stop()
            state = .play
        case .play:
            // Play recording here
            audioRecorder.play()
            return
        }
    }
    
    // MARK - Button Actions
    
    @IBAction func saveTapped(_ sender: Any) {
        guard let fileURL = audioRecorder.fileURL() else {
            return
        }
        delegate?.saved(fileURL)
    }
    
    @IBAction func deleteTapped(_ sender: Any) {
        audioRecorder.delete()
        state = .record
    }
    
    @IBAction func exitTapped(_ sender: Any) {
        audioRecorder.stop()
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
}
