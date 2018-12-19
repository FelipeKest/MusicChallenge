//
//  CKExtensions.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 14/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

extension CKRecord {
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        for item in self.allKeys() {
            result[String(item)] = self.object(forKey: item)
        }
        return result
    }
}


extension Saveable {
    var asCKRecord:CKRecord {
        let record = CKRecord(recordType: String(describing: type(of:self)))
        for item in self.asDictionary {
            record.setValue(item.value, forKey: item.key)
        }
        return record
    }
}

extension Array where Element == Saveable {
    var asCKReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}
