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
                //Fazer tratamento
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
    
//    func inviteTo(band:Band){
//        let bandID = band.id!
//        let invitationCode = bandID+"/"+userID
//        print(invitationCode)
//    }
    
    func add(musician: Musician, band: Band){
        let bandRecord = band.asCKRecord
        let musicianReference = musician.asCKReference
        var bandMembers = bandRecord.value(forKey: "members") as! [CKRecord.Reference]
        bandMembers.append(musicianReference)
        musician.asCKRecord["band"] = band.asCKReference
    }
    
    //MARK: Create Functions
    func createMusician(musician: Musician, completionHandler: @escaping (CKRecord?,Error?)->Void){
        let musicianRecord = CKRecord(recordType: "Musician")
        musicianRecord.setValue(musician.name, forKey: "name")
        musicianRecord.setValue(musician.age, forKey: "age")
        musicianRecord.setValue(musician.instruments, forKey: "instruments")
        musicianRecord.setValue(musician.id, forKey: "id")
        database?.save(musicianRecord, completionHandler: { (record, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                musician.id = record?.recordID.recordName
                completionHandler(record,nil)
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
                band.setlists.append(setlist)
                setlist.id = setlistRecord.recordID.recordName
                completionHandler(setlist,nil)
            }
        })
    }
    
    func createSong(song: Song,by musician: Musician, on band:Band, completionHandler: @escaping (Song?,Error?)->Void){
        var songRecord = CKRecord(recordType: "Song")
        let musicianRecord = CKRecord(recordType: "Musician", recordID: CKRecord.ID(recordName: musician.id!))
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                bandRecord = record!
            }
        }
        
        for musicians in (bandRecord.value(forKey: "members") as? [CKRecord.Reference])! {
            if musicians.recordID == musicianRecord.recordID {
                songRecord.setValue(musician.id, forKey: "creatorID")
            }
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
                user.band = band
                completionHandler(band,nil)
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
                        setlist.songs.append(song)
                    }
                }
            }
        }
    }
    
    func insert(musician:Musician,on band:Band, completionHandler: @escaping (CKRecord?,Error?)->Void){
        var musicianRecord = CKRecord(recordType: "Musician")
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
                        musicianRecord = CKRecord(recordType: "Musician", recordID: searchingMusician.recordID)
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
//        let userRecord = CKRecord(recordType: "Musician")
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
        
        completionHandler(songs.asCKSongReferences,nil)
        return songs
    }
    
    func queryAllSetlists(from band:Band,completionHandler: @escaping([CKRecord.Reference]?,Error?)->Void)->[Setlist]{
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
        
        completionHandler(setlists.asCKSetlistReferences,nil)
        return setlists
    }
    
    func queryAllMusicians(from band:Band, and membersID: [String] = [], completionHandler: @escaping(Error?)->Void){
        var bandMembers = membersID
        for i in 0..<membersID.count {
            if let member = Musician.allReferenced[membersID[i]] as? Musician {
                band.members.append(member)
                bandMembers.remove(at: i)
            }
        }
        if bandMembers.count == 0 {return}
        
        let pred = NSPredicate(format: "id == %@", bandMembers)
        let query = CKQuery(recordType: "Musician", predicate: pred)
        
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
            } else {
                guard let results = results else {return}
                for musician in results {
                    let member = musician.asMusician
                    band.members.append(member)
                }
                completionHandler(nil)
            }
        })
        
    }
    
    func queryAllEvents(from band: Band, completionHandler: @escaping ([CKRecord.Reference]?,Error?)->Void)->[Event]{
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
                            events.append(event)
                        }
                    }
                }
            }
        })
        completionHandler(events.asCKEventsReferences,nil)
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
    
    func queryMusician(id: String, completionHandler: @escaping (CKRecord?,Error?)->Void){
        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(format: "id == %@", id))
//        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(value: true))
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                if (results?.isEmpty)! {
                    //nao tem musicos no Cloud
                    completionHandler(nil,nil)
                } else {
                    //tem musicos
                    for musician in results! {
                        // nao ta funcionando
                        if (musician.object(forKey: "id") as? String == id) {
                            print("achei o record")
                            completionHandler(musician,nil)
                            return
                        }
                    }
                    print(#function, "nao achei record")
                    completionHandler(nil,nil)
                }
            }
        })
    }
    
    //MARK: Fetch Functions
    func fetchCurrentUser(completionHandler: @escaping(CKRecord?,Error?)->Void){
        //se nao e a primeira vez logando pode persistir localmente esse id
        CKContainer.default().fetchUserRecordID { (userRecordID, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                print("error fetching")
                completionHandler(nil,error)
                return
            } else {
                // Fazer tratamento para o usuario logar
                SessionManager.currentUserID = userRecordID?.recordName
                self.queryMusician(id: (userRecordID?.recordName)!, completionHandler: { (userRecord, error) in
                    if error != nil {
                        print(error!.localizedDescription as Any)
                        completionHandler(nil,error)
                        return
                    } else {
                        if userRecord == nil {
                            //Usuario nao existe
                            print("Usuario nao Existe")
                            self.createMusician(musician: Musician(name: "Test2", age: 0, instruments: [], id: userRecordID?.recordName), completionHandler: { (currentUserRecord, error) in
                                if error != nil {
                                    print(error?.localizedDescription as Any)
                                    return
                                } else {
                                    print("criando musico pela primeira vez")
                                    SessionManager.currentUser = currentUserRecord?.asMusician
                                    completionHandler(currentUserRecord,nil)
                                }})
                        } else {
                            // Usuario ja Existe
                            print("record existe")
                            SessionManager.currentUser = userRecord?.asMusician
                            completionHandler(userRecord,nil)
                        }
                    }
                })
            }
        }
    }
    
    func fetchBandFrom(record:Any, into musician: Musician){
        let recordBand = record as? CKRecord
        guard let bandRecord = recordBand else {return}
        let band = Band(asDictionary: bandRecord.asDictionary)
        DAO.queryBand(id: bandRecord.recordID.recordName) { (record, error) in
            guard let record = record else {return}
            musician.band = Band(asDictionary: record.asDictionary)
        }
    }
//    func fetchBand(for userID: String,completionHandler: @escaping(CKRecord?,Error?)-> Void){
//        DAO.queryBand(id: userRecord["bandID"]!, completionHandler: { (bandRecord, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(nil,error)
//                return
//            } else {
//                completionHandler(bandRecord,nil)
//            }
//        })
//    }


    
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
