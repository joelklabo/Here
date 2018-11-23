//
//  RecordingFileProviding.swift
//  here
//
//  Created by Joel Klabo on 7/19/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation

protocol RecordingDelegate {
    func saved(_ recordingURL: URL)
    func cancelled()
}
