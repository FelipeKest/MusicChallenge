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

protocol CurrentUserObserver {
    func currentUserChanged()
}

protocol UserStatusDelegate {
    var userHasLogged: Bool? {get set}
}

class dao: UserStatusDelegate{
    var userHasLogged: Bool?
    
    static let instance = dao()
    public var currentUserObserver: CurrentUserObserver?    
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
    
    func add(musician: Musician, bandID: String,completionHandler: @escaping(Error?)->Void){
        queryBand(id: bandID) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(error)
                return
            }
            guard let musicianID = musician.id else {return}
            self.queryMusician(id: musicianID, completionHandler: { (musicianRecord, musicianError) in
                if musicianError != nil {
                    print(musicianError?.localizedDescription as Any)
                    completionHandler(musicianError)
                    return
                }
                guard let bandRecord = record else {return}
                guard let musicianRecord = musicianRecord else {return}
                //peguei a band
                print(bandRecord["name"] as Any)
                //membros da banda
                guard let bandMembers = bandRecord.value(forKey: "members") as? [CKRecord.Reference] else {return}
                //variavel auxiliar
                var auxiliarBandMembers = bandMembers
                //reference da band
                let bandReference = CKRecord.Reference(record: bandRecord, action: .none)
                //reference do musico
                let musicianReference = CKRecord.Reference(record: musicianRecord, action: .none)
                auxiliarBandMembers.append(musicianReference)
                bandRecord.setValue(auxiliarBandMembers, forKey: "members")
                musicianRecord.setValue(bandReference, forKey: "band")
                let modifierOperation = CKModifyRecordsOperation(recordsToSave: [musicianRecord, bandRecord], recordIDsToDelete: [])
                modifierOperation.modifyRecordsCompletionBlock = { _,_,modifyError in
                    guard modifyError == nil else {
                        guard let cloudError = modifyError as? CKError else {
                            completionHandler(modifyError)
                            return
                        }
                        if cloudError.code == .partialFailure {
                            guard let errors = cloudError.partialErrorsByItemID else {
                                completionHandler(cloudError)
                                return
                            }
                            for (_, error) in errors {
                                if error is CKError {
                                    return
                                }
                            }
                        }
                        completionHandler(error)
                        return
                    }
                    completionHandler(nil)
                }
                self.database?.add(modifierOperation)
            })
        }
    }
//            self.database?.save(bandRecord, completionHandler: { (savedBandRecord, error) in
//                if error != nil {
//                    print(error?.localizedDescription as Any)
//                    return
//                }
//                print("Salvou")
//                self.database?.save(musicianRecord, completionHandler: { (savedMusician, err) in
//                    if err != nil {
//                        print("Entrou!!")
//                        print(err?.localizedDescription as Any)
//                        bandRecord.setValue(bandMembers, forKey: "members")
//                        self.database?.save(bandRecord, completionHandler: { (savedFailedBandRecord, er) in
//                            if er != nil {
//                                print("Entrou 2")
//                                print(er?.localizedDescription as Any)
//                            }
//                        })
//                    }
//                    else{
//                        print("Salvou 2")
//                    }
//                })
//                completionHandler(nil)
//            })
//        }
    
    
    //MARK: Create Functions
    func createMusician(musician: Musician, completionHandler: @escaping (Error?)->Void){
        let musicianRecord = CKRecord(recordType: "Musician")
        musicianRecord.setValue(musician.name, forKey: "name")
        musicianRecord.setValue(musician.age, forKey: "age")
        musicianRecord.setValue(musician.instruments, forKey: "instruments")
        musicianRecord.setValue(musician.id, forKey: "id")
        database?.save(musicianRecord, completionHandler: { (record, error) in
            if error != nil {
                completionHandler(error)
                print(error!.localizedDescription)
                return
            } else {
                musicianRecord.setValue(musicianRecord.recordID.recordName, forKey: "musicianRecordName")
                self.database?.save(musicianRecord, completionHandler: { (recordWithRecordName, error) in
                    if error != nil {
                        print(error?.localizedDescription as Any)
                        return
                    }
                    completionHandler(nil)
                })
            }
        })
    }
    
    func createBand(band: Band,user:Musician, completionHandler: @escaping (Band?,Error?)->Void){
        let bandRecord = CKRecord(recordType: "Band")
        bandRecord.setValue(band.name, forKey: "name")
        bandRecord.setValue(band.id, forKey: "id")
        let musicianReference = [CKRecord.Reference(recordID: CKRecord.ID(recordName: user.musicianRecordName!), action: .none)]
        bandRecord.setValue(musicianReference, forKey: "members")
        database?.save(bandRecord, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
                print(error!.localizedDescription)
                return
            } else {
                //sem erro
                result?.setValue(result?.recordID.recordName, forKey: "id")
                self.database?.save(result!, completionHandler: { (bandResult, err) in
                    if err != nil {
                        print(err?.localizedDescription as Any)
                        completionHandler(nil,err)
                        return
                    }
                    band.id = bandRecord.recordID.recordName
                    band.members.append(user)
                    user.band = band
                    
                    completionHandler(band,nil)
                })
            }
        })
    }

    
//    func createSetlist(setlist: Setlist, creator: Musician, band: Band, completionHandler: @escaping(Setlist?,Error?)->Void){
//        let setlistRecord = CKRecord(recordType: "Setlist")
//        var bandRecord = CKRecord(recordType: "Band")
//        queryBand(id: band.id!) { (record, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(nil,error)
//            } else {
//                bandRecord = record!
//            }
//        }
//        setlistRecord.setValuesForKeys(setlist.asDictionary)
//        database?.save(setlistRecord, completionHandler: { record,error in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(nil,error)
//            } else {
//                //TODO: Pegar e modificar as setlist no campo ["setlist"] do Record da Banda
//                print("saved record")
//                band.setlists.append(setlist)
//                setlist.id = setlistRecord.recordID.recordName
//                completionHandler(setlist,nil)
//            }
//        })
//    }
    
    func createSong(song: Song,by musician: Musician, on band:Band, completionHandler: @escaping (Song?,Error?)->Void){
        let songRecord = CKRecord(recordType: "Song")
        var musicianRecord = CKRecord(recordType: "Musician")
        var bandRecord = CKRecord(recordType: "Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                bandRecord = record!
                self.queryMusician(id: musician.id!) { (musicianRec, err) in
                    if err != nil {
                        print(err?.localizedDescription as Any)
                        completionHandler(nil,err)
                        return
                    }
                    guard let musicianRec = musicianRec else {return}
                    musicianRecord = musicianRec
                    songRecord.setValue(song.name, forKey: "name")
                    let musicianReference = CKRecord.Reference(record: musicianRecord, action: .none)
                    songRecord.setValue(musicianReference, forKey: "creator")
                    guard var bandRepertoire = bandRecord["repertoire"] as? [CKRecord.Reference] else {return}
                    self.database?.save(songRecord, completionHandler: { (savedSongRecord, songError) in
                        if songError != nil {
                            print(songError?.localizedDescription as Any)
                            completionHandler(nil,songError)
                            return
                        }
                        guard let savedSongRecord = savedSongRecord else {return}
                        bandRepertoire.append(CKRecord.Reference(record: savedSongRecord, action: .none))
                        bandRecord.setValue(bandRepertoire, forKey: "repertoire")
                        let modifierOperation = CKModifyRecordsOperation(recordsToSave: [bandRecord], recordIDsToDelete: [])
                        modifierOperation.modifyRecordsCompletionBlock = { _,_,modifyError in
                            guard modifyError == nil else {
                                guard let cloudError = modifyError as? CKError else {
                                    completionHandler(nil,error)
                                    return
                                }
                                if cloudError.code == .partialFailure {
                                    guard let errors = cloudError.partialErrorsByItemID else {
                                        completionHandler(nil,cloudError)
                                        return
                                    }
                                    for (_, error) in errors {
                                        if error is CKError {
                                            return
                                        }
                                    }
                                }
                                completionHandler(nil,error)
                                return
                            }
                            completionHandler(Song(asDictionary: songRecord.asDictionary),nil)
                        }
                        self.database?.add(modifierOperation)

                    })
                }

            }
        }
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
    
    
    func queryAllMusicians(from band:Band, and membersReferences: Any, completionHandler: @escaping(Error?)->Void){
        //O vetor de members
        let allMembersID = membersReferences as! [CKRecord.Reference]
        var bandMembers = allMembersID
        for i in 0..<allMembersID.count {
            //Ve se os membros estao no allReferenced
            print("name do record do member:",allMembersID[i].recordID.recordName)
            print("dicionario de bandas")
            for (key,value) in Band.allReferenced {
                 print("\tkey: \(key) \n\tvalue: \(value)")
            }
            print("dicionario de musicos")
            for (key,value) in Musician.allReferenced {
                print("\tkey: \(key) \n\tvalue: \(value)")
            }
//            Se sim
            if let member = Musician.allReferenced[allMembersID[i].recordID.recordName] {
                //adiciona na banda
                band.members.append(member)
                print("nome do member \(member.name)")
                //retira do vetor
                bandMembers.remove(at: i)
            }
        }
        if bandMembers.count == 0 {return}
        //os que sobraram
        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(value: true))
        //pega do icloud
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print("deu erro")
                print(error?.localizedDescription as Any)
                completionHandler(error)
            } else {
                guard let results = results else {return}
                for musician in results {
                    guard let bandReference = musician["band"] as? CKRecord.Reference else {return}
                    let bandID = bandReference.recordID.recordName
                    guard let wantedID = band.id else {return}
                    if bandID == wantedID {
                        // e um elemento de um nsarray
                        let member = musician.asMusician
                        print(type(of: results))
                        print(type(of: member))
                        print(type(of: band.members))
                        band.members.append(member)
                    }
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
                guard let userRecordName = userRecordID?.recordName else {return}
                SessionManager.currentUserID = userRecordName
                self.queryMusician(id: userRecordName, completionHandler: { (userRecord, error) in
                    if error != nil {
                        print(error!.localizedDescription as Any)
                        completionHandler(nil,error)
                        return
                    } else {
                        if userRecord == nil {
                            //Usuario nao existe
                            print("Usuario nao Existe")
//                            self.createMusician(musician: Musician(name: "Guilherme", age: 25, instruments:[],band:Band(), id: userRecordName), completionHandler: { (currentUserRecord, error) in
//                                if error != nil {
//                                    print(error?.localizedDescription as Any)
//                                    return
//                                } else {
//                                    print("criando musico pela primeira vez")
//                                    guard let currentUser = currentUserRecord?.asMusician else {return}
//                                    SessionManager.currentUser = currentUser
//                                    completionHandler(currentUserRecord,nil)
//                                }})
                            self.userHasLogged = false
                            completionHandler(nil,nil)
                        } else {
                            // Usuario ja Existe
                            print("record existe")
                            guard let user = userRecord?.asMusician else {return}
                            SessionManager.currentUser = user
                            self.userHasLogged = true
                            completionHandler(userRecord,nil)
                        }
                    }
                })
            }
        }
    }
    
    //Pega informacoes do usuario
    //CKContainer.default().discoverUserIdentity(withUserRecordID: <#T##CKRecord.ID#>, completionHandler: <#T##(CKUserIdentity?, Error?) -> Void#>)

    
//    func fetchBandFrom(record:CKRecord, into musician: Musician){
//        DAO.queryBand(id: record.recordID.recordName) { (bandRecord, error) in
//            guard let realbandRecord = bandRecord else {
//                print("Error in fetching record")
//                return
//            }
//            let band: Band
//
//
//            print("printei a banda")
//            print(musician.band?.name as Any)
//        }
//    }
    
    func fetchBand(with id:String, completionHandler: @escaping(CKRecord?,Error?)-> Void){
        let recordID = CKRecord.ID(recordName: id)
        DAO.database?.fetch(withRecordID: recordID, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
                return
            }
            guard let bandRecord = result else {
                completionHandler(nil,nil)
                return
            }
            completionHandler(bandRecord,error)
            
        })
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
    
//    func delete(song: Song, from band: Band, completionHandler: @escaping(CKRecord.ID?,Error?)->Void){
//        DAO.database?.delete(withRecordID: CKRecord.ID(recordName: song.id!), completionHandler: { (result, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(nil,error)
//                return
//            } else {
//                var index = 0
//                for repertoireSong in band.repertoire {
//                    if repertoireSong.id == song.id {
//                        band.repertoire.remove(at: index)
//                    }
//                    index += 1
//                }
//                completionHandler(result,nil)
//            }
//        })
//    }
    
    
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
    
    func saveRecord(record: CKRecord, completion: @escaping (CKRecord) -> CKRecord) {
        let recordToSave = completion(record)
        let modify = CKModifyRecordsOperation(recordsToSave: [recordToSave], recordIDsToDelete: nil)
        
        modify.qualityOfService = .userInteractive
        modify.perRecordCompletionBlock = {
            [weak self] (record: CKRecord?, error: Error?) -> Void in
            if let ckError = error as? CKError {

                // Check if the record was changed in the server
                if ckError.code == CKError.Code.serverRecordChanged {
                    
                    print(ckError.code.rawValue)
                    
                    let serverRecord = ckError.userInfo["ServerRecord"]
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + (ckError.retryAfterSeconds ?? 0)) {
                        self!.saveRecord(record: serverRecord as! CKRecord, completion: completion)
                    }
                }
                
            }
                
            else {
                //change the value
                print("record saved")
                
            }
        }
        
        modify.savePolicy = .ifServerRecordUnchanged
        
        self.container.publicCloudDatabase.add(modify)
    }

}
