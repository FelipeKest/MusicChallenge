//
//  DAO.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

//Para retornar o dao para um singleton descomentar as duas linhas abaixo
let DAO = dao.instance

class dao{
    static let instance = dao()
    private var database:CKDatabase?
    private let container = CKContainer(identifier: "iCloud.FelipeKestelman.MusicChallenge")
    
    private init(){
        self.configureCloud()
    }
    
    private func configureCloud(){
        
        database = container.publicCloudDatabase
        
        container.accountStatus{(status, error) -> Void in
            
            if status == .noAccount{
                print("Sem acesso no iCloud")
            }
        }
    }
    
    //MARK: Create Functions
//    func createMusician(musician: Musician, completionHandler: @escaping (Musician?,Error?)->Void){
//        let musicianRecord = CKRecord(recordType: "Users")
//        musicianRecord.setValue(musician.name, forKey: "name")
//        musicianRecord.setValue(musician.age, forKey: "age")
//        musicianRecord.setValue(musician.instruments.asCKReferences, forKey: "instruments")
//        database?.save(musicianRecord, completionHandler: { (record, error) in
//            if error != nil {
//                completionHandler(nil,error)
//                print(error!.localizedDescription)
//                return
//            } else {
//                musician.id = record?.recordID.recordName
//                completionHandler(musician,nil)
//            }
//        })
//    }
    
    func createSong(song: Song, on band:Band, completionHandler: @escaping (Song?,Error?)->Void){
        let songRecord = CKRecord(recordType: "Song")
        songRecord.setValuesForKeys(song.asDictionary)
        database?.save(songRecord, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                print("saved record")
                song.id = result?.recordID.recordName
                band.repertoire.append(song)
//                song.bandId = band.id!
                completionHandler(song, nil)
            }
        })
    }
    
//    func createSetlist(setlist: Setlist, on band:Band, completionHandler: @escaping (Setlist?,Error?)->Void){
//        let setlistRecord = CKRecord(recordType: "Setlist")
////        setlistRecord.setObject(setlist.name as CKRecordValue, forKey: "Name")
////        setlistRecord.setValuesForKeys(setlist.asDictionary)
//        setlistRecord.setValue(setlist.name, forKey: "name")
//        setlistRecord.setValue(setlist.songs.asCKReferences, forKey: "songs")
//        database?.save(setlistRecord, completionHandler: { (result, error) in
//            if error != nil {
//                completionHandler(nil,error)
//                print(error!.localizedDescription)
//                return
//            } else {
//                print("saved record")
//                setlist.id = result?.recordID.recordName
//                band.setlists.append(setlist)
////                setlist.bandId = band.id!
//                completionHandler(setlist,nil)
//            }
//        })
//    }
    
    func create<T: GenericProtocolClass>(type: T, on band:Band, completionHandler: @escaping (T?,Error?)->Void){
//        let typeRecord = CKRecord(recordType: T)
        
    }
  
//    func createUser(user: Musician, completionHandler: @escaping(Musician?,Error?)->Void){
//        let userRecord = CKRecord(recordType: "Users")
//        userRecord.setValuesForKeys(user.asDictionary)
//        database?.save(userRecord, completionHandler: { (record, error) in
//            if error != nil {
//                completionHandler(nil,error)
//                print(error!.localizedDescription)
//                return
//            } else {
//                user.id = record?.recordID.recordName
//                completionHandler(user,nil)
//            }
//        })
//    }
    
    //MARK: QueryAll Functions
    func queryAllSongs(from band:Band, completionHandler: @escaping(Song?,Error?)->Void)->[Song]{
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(value: true))
        var songs: [Song] = []
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
            } else {
                //Pegou as Bandas
                for record in results! {
                    //Para cada banda ve se e a banda procurada
                    if (record.recordID.recordName == band.id){
                        //Para cada musica no dicionario
                        for song in record.asDictionary["repertoire"] as! [Song]{
                            completionHandler(song,nil)
                            songs.append(song)
                        }
                    }
                }
            }
        })
        return songs
    }
    
    func queryAllSetlists(from band:Band,completionHandler: @escaping(Setlist?,Error?)->Void)->[Setlist]{
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(value: true))
        var setlists: [Setlist] = []
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
            } else {
                //Pegou as Setlist
                for record in results! {
                    //Para cada banda ve se e a banda procurada
                    if (record.recordID.recordName == band.id){
                        //Para cada musica no dicionario
                        for setlist in record.asDictionary["setlist"] as! [Setlist]{
                            completionHandler(setlist,nil)
                            setlists.append(setlist)
                        }
                    }
                }
            }
        })
        return setlists
    }
    
    func queryAllMusicians(from band:Band, completionHandler: @escaping(Musician?,Error?)->Void)->[Musician]{
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(value: true))
        var musicians: [Musician] = []
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                //Pegou as Bandas
                for record in results! {
                    //Para cada banda ve se e a banda procurada
                    if (record.recordID.recordName == band.id){
                        //Para cada musico no dicionario
                        for musician in record.asDictionary["members"] as! [Musician]{
                            completionHandler(musician,nil)
                            musicians.append(musician)
                        }
                    }
                }
            }
        })
        return musicians
    }
    
    func queryAllEvents(from band: Band, completionHandler: @escaping (Event?,Error?)->Void)->[Event]{
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(value: true))
        var events: [Event] = []
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                //Pegou as Bandas
                for record in results! {
                    //Para cada banda ve se e a banda procurada
                    if (record.recordID.recordName == band.id){
                        //Para cada evento no dicionario
                        for event in record.asDictionary["events"] as! [Event]{
                            completionHandler(event,nil)
                            events.append(event)
                        }
                    }
                }
            }
        })
        return events
    }
    
    //MARK: Delete Functions
    
    func delete(song: Song, from band: Band, completionHandler: @escaping(CKRecord.ID?,Error?)->Void){
        DAO.database?.delete(withRecordID: CKRecord.ID(recordName: song.id!), completionHandler: { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                var index = 0
                for repertoireSong in band.repertoire {
                    if repertoireSong.id == song.id {
                        band.repertoire.remove(at: index)
                    }
                    index += 1
                }
                completionHandler(result,nil)
            }
        })
    }
    
    
    func deletePlaylist(playlist: CKRecord, from band: Band,completionHandler: @escaping(CKRecord.ID?,Error?)->Void){
        DAO.database?.delete(withRecordID: playlist.recordID, completionHandler: { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                completionHandler(result,nil)
            }
        })
    }
    
    //Tentando
    
//    func delete<T:GenericProtocolClass>(type:T,from band: Band,completionHandler: @escaping(CKRecord.ID?,Error?)->Void){
//        DAO.database?.delete(withRecordID: type.asCKRecord.recordID, completionHandler: { (recordID, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(nil,error)
//                return
//            } else {
//                completionHandler(recordID,error)
//                switch type(of: type) {
//                case is Song:
//                    print("song")
//                case is Setlist:
//                    print(type(of: type))
//                }
//            }
//        })
//    }
    
    
}
