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
    
    private func checkLoginStatus(_ completionHandler: @escaping (_ islogged: Bool) -> Void) {
        CKContainer.default().accountStatus{ accountStatus, error in
            if let error = error {
                print(error.localizedDescription)
            }
            switch accountStatus {
            case .available:
                completionHandler(true)
            default:
                completionHandler(false)
            }
        }
    }
    
    //MARK: Create Functions
    func createMusician(musician: Musician, completionHandler: @escaping (Musician?,Error?)->Void){
        let musicianRecord = CKRecord(recordType: "Users")
        musicianRecord.setValue(musician.name, forKey: "name")
        musicianRecord.setValue(musician.age, forKey: "age")
        musicianRecord.setValue(musician.instruments, forKey: "instruments")
        database?.save(musicianRecord, completionHandler: { (record, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                musician.id = record?.recordID.recordName
                completionHandler(musician,nil)
            }
        })
    }

    
    func createSetlist(setlist: Setlist, creator: Musician, band: Band, completionHandler: @escaping(Setlist?,Error?)->Void){
        let setlistRecord = CKRecord(recordType: "Setlist")
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
            } else {
                bandRecord = record!
            }
        }
        setlistRecord.setValuesForKeys(setlist.asDictionary)
        database?.save(setlistRecord, completionHandler: { record,error in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
            } else {
                //TODO: Pegar e modificar as setlist no campo ["setlist"] do Record da Banda
                print("saved record")
                setlist.id = setlistRecord.recordID.recordName
                setlist.bandID = bandRecord.recordID.recordName
                completionHandler(setlist,nil)
            }
        })
    }
    
    func createSong(song: Song,by: Musician, on band:Band, completionHandler: @escaping (Song?,Error?)->Void){
        var songRecord = CKRecord(recordType: "Song")
        var musicianRecord = CKRecord(recordType: "Users")
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                bandRecord = record!
            }
        }
        
        for musicians in (bandRecord.value(forKey: "members") as? [CKRecord.Reference])! {
            
        }
        
        songRecord = song.asCKRecord
        database?.save(songRecord, completionHandler: {(result, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                //TODO: Pegar e modifcar as musicas no campo ["repertoire"] do Record da Banda
                print("saved record")
                songRecord.setValue(result?.recordID.recordName, forKey: "id")
                songRecord.setValue(bandRecord.recordID.recordName, forKey: "bandID")
                completionHandler(song, nil)
            }
        })
    }
    
    //MARK: Insert Function
    func insert(song:Song,on setlist:Setlist,of band:Band, completionHandler: @escaping (CKRecord?,Error?)->Void){
        var songRecord = CKRecord(recordType: "Song")
        var setlistRecord = CKRecord(recordType: "Setlist")
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                //sem erro
                bandRecord = record!
                for searchingSong in bandRecord.value(forKey: "repertoire") as! [CKRecord.Reference]{
                    if searchingSong.recordID == songRecord.recordID {
                        songRecord = CKRecord(recordType: "Song", recordID: searchingSong.recordID)
                    }
                }
    
                for searchingSetlist in bandRecord.value(forKey: "setlists") as! [CKRecord.Reference]{
                    if searchingSetlist.recordID == setlistRecord.recordID {
                        setlistRecord = CKRecord(recordType: "Setlist", recordID: searchingSetlist.recordID)
                        var searchedSetlistSongs = setlistRecord.value(forKey: "songs") as! [CKRecord.Reference]
                        searchedSetlistSongs.append(CKRecord.Reference(record: songRecord, action: .none))
                        self.database?.save(setlistRecord, completionHandler: { (record, error) in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                completionHandler(nil,error)
                            } else {
                                completionHandler(record,nil)
                            }
                        })
                        song.setlistsIn.append(setlist)
                        setlist.songs.append(song)
                    }
                }
            }
        }
    }
    
    func insert(musician:Musician,of band:Band, completionHandler: @escaping (CKRecord?,Error?)->Void){
        var musicianRecord = CKRecord(recordType: "Users")
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                //sem erro
                bandRecord = record!
                for searchingMusician in bandRecord.value(forKey: "members") as! [CKRecord.Reference]{
                    if searchingMusician.recordID == musicianRecord.recordID {
                        musicianRecord = CKRecord(recordType: "Users", recordID: searchingMusician.recordID)
                        self.database?.save(musicianRecord, completionHandler: { (record, error) in
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                completionHandler(nil,error)
                            } else {
                                completionHandler(record,nil)
                            }
                        })
                       
                    }
                }
            }
        }
        band.members.append(musician)
    }
    
    
    
    func createBand(band: Band,user:Musician, completionHandler: @escaping (Band?,Error?)->Void){
        var bandRecord = CKRecord(recordType: "Band")
        bandRecord = band.asCKRecord
        database?.save(bandRecord, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                //sem erro
                band.id = bandRecord.recordID.recordName
                band.members.append(user)
                user.bandID = band.id!
                completionHandler(band,nil)
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
    
//    func create<T: GenericProtocolClass>(type: T, on band:Band, completionHandler: @escaping (T?,Error?)->Void){
//    //
//    }
  
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
//                completionHandler(user,nil)@
//            }
//        })
//    }
    
    //MARK: QueryAll Functions
    func queryAllSongs(from band:Band, completionHandler: @escaping([CKRecord.Reference]?,Error?)->Void)->[Song]{
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
                            songs.append(song)
                        }
                    }
                }
            }
        })
        //Resolver Problema dos Models com o Ricardo para resolver isso embaixo
        
//        completionHandler(songs.asCKReferences,nil)
        return songs
    }
    
    func queryAllSetlists(from band:Band,completionHandler: @escaping([Setlist]?,Error?)->Void){
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
                            setlists.append(setlist)
                        }
                    }
                }
            }
        })
        completionHandler(setlists,nil)
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
                return
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
    
    //MARK: Query Functions
    
    func queryBand(id: String, completionHandler: @escaping(CKRecord?,Error?)->Void){
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(value: true))
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                for record in results! {
                    if (record.recordID.recordName == id) {
                        completionHandler(record,nil)
                    }
                }
            }
        })
    }
    
    
    func fetchCurrentUser(completionHandler: @escaping(CKRecord?,Error?)->Void){
        let query = CKQuery(recordType: "Users", predicate: NSPredicate(value: true))
        var userID: String = ""
        CKContainer.default().fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                userID = (userRecordID?.recordName)!
                DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
                    if error != nil{
                        print(error?.localizedDescription as Any)
                        completionHandler(nil,error)
                        return
                    } else {
                        for userRecord in records! {
                            if userRecord.recordID.recordName == userID {
                                completionHandler(userRecord,nil)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func fetchCurrentUserBand(completionHandler: @escaping(CKRecord?,Error?)->Void){
        fetchCurrentUser { (userRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                DAO.queryBand(id: userRecord!["bandID"]!, completionHandler: { (bandRecord, error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        completionHandler(nil,error)
                        return
                    } else {
                        completionHandler(bandRecord,nil)
                    }
                })
            }
        }
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
