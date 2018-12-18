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
                print(error!)
            }
        }
    }
    
    //MARK: Create Functions
    func createSong(song: Song, completionHandler: @escaping (Song?,Error?)->Void){
        let songRecord = CKRecord(recordType: "Song")
        songRecord.setObject(song.name as CKRecordValue?, forKey: "name")
        songRecord.setObject(song.instruments as CKRecordValue?, forKey: "instruments")
        database?.save(songRecord, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
            } else {
                song.id = result?.recordID.recordName
                completionHandler(song, nil)
            }
        })
    }
    
    func createSetlist(Setlist: Setlist, completionHandler: @escaping (CKRecord?,Error?)->Void){
        let SetlistRecord = CKRecord(recordType: "Setlist")
        SetlistRecord.setObject(Setlist.name as CKRecordValue?, forKey: "name")
        SetlistRecord.setObject(Setlist.songs as  CKRecordValue?, forKey: "Songs")
        database?.save(SetlistRecord, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
            } else {
                completionHandler(result, nil)
            }
        })
    }
    
    
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
}
