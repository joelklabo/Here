//
//  RecordingAnnotationView.swift
//  here
//
//  Created by Joel Klabo on 7/9/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import UIKit
import MapKit

class RecordingAnnotationView: MKAnnotationView {
}

class RecordingAnnotation: NSObject, MKAnnotation {
    init(_ recording: Recording, _ location: CLLocationCoordinate2D) {
        self.recording = recording
        self.coordinate = location
        super.init()
    }
    let coordinate: CLLocationCoordinate2D
    let recording: Recording
}

class PendingRecordingAnnotation: NSObject, MKAnnotation {
    init(_ location: CLLocationCoordinate2D) {
        self.coordinate = location
        super.init()
    }
    let coordinate: CLLocationCoordinate2D
}
