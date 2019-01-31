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
    
    func load(band: Band, from dict:[String:Any], completionHandler: @escaping(Error?)->Void){
        band.name = dict["name"] as! String
        band.id = dict["id"] as? String
        print("daoLoad")
        if let membersID = dict["members"] {
            DAO.queryAllMusicians(from: band, with: membersID) { (membersError) in
                if membersError != nil {
                    print(membersError?.localizedDescription as Any)
                    completionHandler(membersError)
                    return
                }
                if let songsID = dict["repertoire"] {
                    DAO.queryAllSongs(from: band, songsReferences: songsID, completionHandler: { (songsError) in
                        if songsError != nil {
                            print(songsError?.localizedDescription as Any)
                            completionHandler(songsError)
                            return
                        }
                        if let setlistsID = dict["setlists"] {
                            DAO.queryAllSetlists(from: band, with: setlistsID,completionHandler: { (setlistsError) in
                                print(setlistsError?.localizedDescription as Any)
                                completionHandler(setlistsError)
                                return
                            })
                            completionHandler(nil)
                        }
                    })
                }
            }
        }
    }
    
    func load(musician: Musician, from dict: [String:Any], band: Band? = nil, completionHandler: @escaping(Error?)->Void){
        musician.name = dict["name"] as! String
        musician.age = dict["age"] as! Int
        guard let instrumentsString = dict["instruments"] as? [String] else {return}
        var instruments: [Instrument] = []
        for instrument in instrumentsString {
            instruments.append(instrument.asInstrument)
        }
        musician.instruments = instruments
        musician.id = dict["id"] as? String
        guard let musicianRecordName = dict["musicianRecordName"] as? String else {return}
        musician.musicianRecordName = musicianRecordName
        if band == nil {
            if let bandReference = dict["band"] as? CKRecord.Reference {
                DAO.fetchBand2(with: bandReference.recordID.recordName) { (bandRecord, error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        completionHandler(error)
                    }
                }
            }
        }
        musician.band = band
        completionHandler(nil)
    }
    
    func load(from dict:[String:Any], completionHandler: @escaping(Song?,Error?)->Void){
        let name = dict["name"] as! String
        guard let id = dict["id"] as? String else {return}
        var songMusicians:[SongMusician] = []
        if let musicians = dict["players"] as? [CKRecord.Reference] {
            //adiciona nos songMusiciansx
            //buscar musicos no iCloud
            DAO.queryPlayers(from: id) { (players, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(nil,error)
                }
                guard let players = players else {return}
                songMusicians = players
            }
        }

        var instruments: [Instrument] = []
        if let instrumentsString = dict["instruments"] as? [String] {
            for instrument in instrumentsString {
                instruments.append(instrument.asInstrument)
            }
        }
        
        if let creator = dict["creator"] as? CKRecord.Reference {
            print("******\nNO LOAD DA SONG \nrecordName do creator",creator.recordID.recordName)
            //pegar o id do icloud do cara
            DAO.fetchMusician(id: creator.recordID.recordName) { (musician, error) in
                if error != nil {
                    print(error?.localizedDescription as Any)
                    completionHandler(nil,error)
                } else {
                    guard let creator = musician else {return}
                    let song = Song(name: name, instruments: songMusicians, creator: creator, id: id)
                    completionHandler(song,nil)
                }
            }
        }
    }
}
