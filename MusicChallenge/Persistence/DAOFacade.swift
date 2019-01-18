//
//  DAOFacade.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 17/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

let DAOFacade = daofacade.instance

class daofacade {
    static let instance = daofacade()
    
    private init(){
        
    }
    
    func load(band: Band, from dict:[String:Any], completionHandler: @escaping(Band?,Error?)->Void){
        let bandName = dict["name"]
        var bandMusicians:[Musician] = []
        var bandSongs:[Song] = []
        var bandSetlists:[Setlist] = []
        if let membersID = dict["members"] {
            DAO.queryAllMusicians(from: band, and: membersID) { (membersError) in
                
            }
        }
    }
    
    func load(musician: Musician, from dict: [String:Any], completionHandler: @escaping(Error?)->Void){
        musician.name = dict["name"] as! String
        musician.age = dict["age"] as! Int
        let instrumentsString = dict["instruments"] as! [String]
        var instruments: [Instrument] = []
        for instrument in instrumentsString {
            instruments.append(instrument.asInstrument)
        }
        musician.instruments = instruments
        musician.id = dict["id"] as? String
        guard let musicianRecordName = dict["musicianRecordName"] as? String else {return}
        musician.musicianRecordName = musicianRecordName
        if let bandReference = dict["band"] as? CKRecord.Reference {
            DAO.fetchBand(with: bandReference.recordID.recordName) { (bandRecord, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(error)
                }
            }
            
        }
    }
}
