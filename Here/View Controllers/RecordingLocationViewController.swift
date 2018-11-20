//
//  RecordingLocationViewController.swift
//  here
//
//  Created by Joel Klabo on 7/17/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import CoreLocation

class RecordingLocationViewController: ContainedStackViewController {
    
    let locationViewController: LocationViewController
    let recorderViewController: RecorderViewController
    
    var delegate: ViewControllerDismissing?
    
    convenience init(withRecording recording: Recording) {
        self.init(withLocation: recording.location, andRecording: recording)
    }
    
    convenience init(withLocation location: CLLocation) {
        self.init(withLocation: location, andRecording: nil)
    }
    
    init(withLocation location: CLLocation, andRecording recording: Recording?) {
        
        self.locationViewController = LocationViewController.init(withLocation: location)
        self.recorderViewController = RecorderViewController()
        self.recorderViewController.recording = recording
        
        let viewControllers = [locationViewController, recorderViewController]
        super.init(witViewControllers: viewControllers, axis: .vertical)

        recorderViewController.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

}

extension RecordingLocationViewController: RecordingFileProviding {
    
    func saved(_ recordingURL: URL) {
        let location = locationViewController.location
        let recording = Recording(fileURL: recordingURL, location: location)
        DataService.save(recording) { result in
            switch result {
            case .success(let recording):
                print("success: \(recording)")
            case .error(let error):
                print("error: \(error)")
            }
            // Do something?
            self.delegate?.dismiss()
        }
    }
    
}

extension RecordingLocationViewController: ViewControllerDismissing {
    func dismiss() {
        delegate?.dismiss()
    }
}

