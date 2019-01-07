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



//MARK: CKRecords Extension


extension Saveable {
    var asCKRecord:CKRecord {
        let record = CKRecord(recordType: String(describing: type(of:self)))
        for item in self.asDictionary {
            //se o valor do item e saveble
            if let value = item.value as? GenericProtocolClass {
                record.setValue(CKRecord.Reference(record: value.asCKRecord, action: .none), forKey: item.key)
            } else if let value = item.value as? [GenericProtocolClass]{
                var CKReferenceArray: [CKRecord.Reference] = []
                for index in value {
                    CKReferenceArray.append(CKRecord.Reference(record: index.asCKRecord, action: .none))
                }
                record.setValue(CKReferenceArray, forKey: item.key)
            } else {
                record.setValue(item.value, forKey: item.key)
            }
        }
        return record
    }
    var asCKReference:CKRecord.Reference {
        let record = self.asCKRecord
        let recordReference = CKRecord.Reference(record: record, action: .none)
        return recordReference
    }
}

//MARK: CKReferences Extension

extension Array where Element == Band {
    var asCKBandReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}

extension Array where Element == Event {
    var asCKEventsReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}

extension Array where Element == Musician {
    var asCKMusicianReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}

extension Array where Element == Song {
    var asCKSongReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}

extension Array where Element == Setlist {
    var asCKSetlistReferences: [CKRecord.Reference] {
        var result: [CKRecord.Reference] = []
        for item in self {
            let reference = CKRecord.Reference(record: item.asCKRecord, action: .none)
            result.append(reference)
        }
        return result
    }
}







//
//extension Band {
//    var asBandRecord: CKRecord {
//        let record = CKRecord(recordType: String(describing: type(of: self)))
//        record.setValue(self.name, forKey: "name")
//        record.setValue(self.members.asCKReferences, forKey: "members")
//        record.setValue(self.m, forKey: <#T##String#>)
//    }
//}
