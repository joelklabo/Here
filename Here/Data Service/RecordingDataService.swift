//
//  RecordingDataService.swift
//  here
//
//  Created by Joel Klabo on 7/3/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation
import CoreLocation

typealias RecordingDataServiceSaveCompletion = (Result<Recording>) -> ()
typealias RecordingDataServiceQueryCompletion = (Result<[Recording]>) -> ()

protocol RecordingDataService {
    static func save(_ recording: Recording, completion: @escaping RecordingDataServiceSaveCompletion)
    static func queryRecordings(_ location: CLLocation, completion: @escaping RecordingDataServiceQueryCompletion)
}

struct DataService : RecordingDataService {
    static func save(_ recording: Recording, completion: @escaping RecordingDataServiceSaveCompletion) {
        CloudKitRecordingDataService.save(recording, completion: completion)
    }
    
    static func queryRecordings(_ location: CLLocation, completion: @escaping RecordingDataServiceQueryCompletion) {
        CloudKitRecordingDataService.queryRecordings(location, completion: completion)
    }
}
