//
//  CKExtensions.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 14/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

//MARK: CKRecords Extension

extension CKRecord {
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        for item in self.allKeys() {
            result[String(item)] = self.object(forKey: item)
            print("key: \(item) for object: \(String(describing: self.object(forKey: item)))")
        }
        return result
    }
    
    var asMusician: Musician {
        return Musician(asDictionary: self.asDictionary)
    }
    
    var asSong: Song {
        return Song(asDictionary: self.asDictionary)
//        let song: Song
//        let name = self.value(forKey: "name") as! String
//        let instruments = self.value(forKey: "instruments") as! [Instrument]
//        let creatorReference = self.value(forKey: "creator") as? CKRecord.Reference
//        let creatorRecord = CKRecord(recordType: "Song", recordID: (creatorReference?.recordID)!)
//        let id = self.value(forKey: "id") as! String
//        song = Song(name: name, instruments: instruments, creator: creatorRecord.asMusician, id: id)
//        return song
    }
    
    var asSetlist: Setlist {
        let musician = Setlist(asDictionary: self.asDictionary)
        return musician
    }
    
    var asBand: Band {
        return Band(asDictionary: self.asDictionary)
    }
}


//MARK: CKREferences Extension
extension CKRecord.Reference {
    var asDictionary: [String:Any] {
        var result = CKRecord(recordType: "",recordID: self.recordID)
        return result.asDictionary
    }
}

//MARK: CKRecord Array Extension
extension Array where Element == CKRecord {
    var asMusicianArray: [Musician] {
        var array: [Musician] = []
        for musicianRecord in self {
            array.append(musicianRecord.asMusician)
        }
        return array
    }
    
    var asSetlistArray: [Setlist] {
        var array: [Setlist] = []
        for setlistRecord in self {
            array.append(setlistRecord.asSetlist)
        }
        return array
    }
    
    var asSongArray: [Song] {
        var array: [Song] = []
        for songRecord in self {
            array.append(songRecord.asSong)
        }
        return array
    }
}

extension Array where Element == GenericProtocolClass {
    func add(){}
    func remove(){}
}

extension Saveable {
    var asCKRecord:CKRecord {
        let record = CKRecord(recordType: String(describing: type(of:self)))
        for item in self.asDictionary {
            //se o valor do item e saveble
            if let value = item.value as? GenericProtocolClass {
                //reference dos caras
                //record.setValue(CKRecord.Reference(record: value.asCKRecord, action: .none), forKey: item.key)
                if type(of: value) == Musician.self {
                    let musician = value as? Musician
                    record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: (musician?.musicianRecordName)!), action: .none), forKey: item.key)
                } else {
                    record.setValue(CKRecord.Reference(recordID: CKRecord.ID(recordName: value.id!), action: .none), forKey: item.key)
                }
            } else if let value = item.value as? [GenericProtocolClass]{
                var CKReferenceArray: [CKRecord.Reference] = []
                for index in value {
                    if type(of: index) == Musician.self {
                        let musician = index as? Musician
                        CKReferenceArray.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: (musician?.musicianRecordName)!), action: .none))
                    } else {
                        CKReferenceArray.append(CKRecord.Reference(recordID: CKRecord.ID(recordName: index.id!), action: .none))
                    }
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

//MARK: Array to CKReferences Extension

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

//MARK: CKReference to GenericClass Array








//
//extension Band {
//    var asBandRecord: CKRecord {
//        let record = CKRecord(recordType: String(describing: type(of: self)))
//        record.setValue(self.name, forKey: "name")
//        record.setValue(self.members.asCKReferences, forKey: "members")
//        record.setValue(self.m, forKey: <#T##String#>)
//    }
//}
