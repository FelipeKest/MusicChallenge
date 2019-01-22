//
//  Musico.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Musician:GenericProtocolClass {

    var name: String
    var age: Int
    var instruments: [Instrument]?
    var musicianRecordName: String?
    var band: Band?
    
    static var allReferenced:[String:Musician] = [:]
    
    init(name: String, age: Int, instruments: [Instrument] = [],band: Band?,id: String, musicianRecordName: String?) {
        self.name = name
        self.age = age
        self.instruments = instruments
        self.musicianRecordName = musicianRecordName
        self.band = band
        super.init(id: id)
        if let recordName = musicianRecordName {
            Musician.allReferenced[recordName] = self
        }
    }
    
    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["age"] = self.age
        result["instruments"] = self.instruments
        result["band"] = self.band?.asCKReference
        result["id"] = super.id
        return result
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.age = asDictionary["age"] as! Int
        print("banda do model", asDictionary["band"] as Any)
        super.init(id: asDictionary["id"] as? String)

        guard let musicianRecordName = asDictionary["musicianRecordName"] as? String else {return}
        
        DAOFacade.load(musician: self, from: asDictionary) { (error) in
            if error == nil {
                Musician.allReferenced[musicianRecordName] = self
            }
        }
    }
    
        // se o currentUser já existe eu ou um membro da banda
//        guard let bandID = asDictionary["band"] as? [String:Any] else {return} //da um erro
//        let selfBandRecord = CKRecord(recordType: "Band", recordID: selfBandReference.recordID)

        
//        DAO.fetchBandFrom(record: selfBandRecord, into: self)

        
//        if let band = Band.allReferenced[bandID] as? Band {
//            self.band = band
//            print("e a band \(bandID) com name \(band.name)")
//            // se não, pega a banda
//        } else {
//            DAO.queryBand(id: asDictionary["band"] as! String, completionHandler: { (bandRecord, error) in
//                guard let bandDic = bandRecord?.asDictionary else {return}
//                self.band = Band(asDictionary: bandDic)
//                print("e a band \(bandID) com name \(self.band?.name)")
//            })
//
//        }
    
    convenience init (){
//        self.init(name: "Convenience Musician", age: 0, instruments: [],band:Band(), id: "Convenience")
        self.init(name: "Blaaa", age: 10, band: Band(), id: "Convenience", musicianRecordName: nil)
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
}
