//
//  CloudKitRecordingDataService.swift
//  here
//
//  Created by Joel Klabo on 7/3/18.
//  Copyright © 2018 Big Applications. All rights reserved.
//

import Foundation
import CloudKit

struct CloudKitRecordingDataService : RecordingDataService {
    
    static func save(_ recording: Recording, completion: @escaping RecordingDataServiceSaveCompletion) {
        let record = CKRecord(recordType: "Recording")
        let asset = CKAsset(fileURL: recording.fileURL)
        record.setValue(asset, forKey: "asset")
        record.setValue(recording.location, forKey: "location")
        
        let publicDatabase = CKContainer.default().publicCloudDatabase
        publicDatabase.save(record) { (record, error) in
            if let record = record {
                completion(.success(self.recordingFromRecord(record)))
            } else if let error = error {
                completion(.error(error))
            } else {
                fatalError("this should not occur")
            }
        }
    }
    
    static func queryRecordings(_ location: CLLocation, completion: @escaping RecordingDataServiceQueryCompletion) {
        let publicDatabase = CKContainer.default().publicCloudDatabase
        let locationPredicate = NSPredicate(value: true)
        let recordingQuery = CKQuery(recordType: "recording", predicate: locationPredicate)
        recordingQuery.sortDescriptors = [CKLocationSortDescriptor(key: "location", relativeLocation: location)]
        
        publicDatabase.perform(recordingQuery, inZoneWith: nil) { records, error in
            if let records = records {
                completion(.success(self.recordingsFromRecords(records)))
            } else if let error = error {
                completion(.error(error))
            } else {
                fatalError("this should not occur")
            }
        }
    }
    
    // MARK: Private Helpers
    
    static private func recordingsFromRecords(_ records: [CKRecord]?) -> [Recording] {
        if let records = records {
            return records.map { record in
                return self.recordingFromRecord(record)
            }
        } else {
            return []
        }
    }
    
    static private func recordingFromRecord(_ record: CKRecord) -> Recording {
        let asset = record.value(forKey: "asset") as! CKAsset
        let location = record.value(forKey: "location") as! CLLocation
        return Recording(fileURL: asset.fileURL, location: location)
    }
}
