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

class dao {
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
    
    func createBand(band: Band,user:Musician, completionHandler: @escaping (Error?)->Void){
        queryMusician(id: user.id!) { (musicianRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(error)
                return
            }
            let bandRecord = CKRecord(recordType:"Band")
            bandRecord.setValue(band.name, forKey:"name")
            bandRecord.setValue(band.id, forKey:"id")
//            let musicianReference = [CKRecord.Reference(recordID: CKRecord.ID(recordName: user.musicianRecordName!), action: .none)]
            let musicianReference = [CKRecord.Reference(record: musicianRecord!, action: .none)]
            bandRecord.setValue(musicianReference, forKey:"members")
            self.database?.save(bandRecord, completionHandler: { (result, error) in
                if error != nil {
                    completionHandler(error)
                    print(error!.localizedDescription)
                    return
                } else {
                    //sem erro
                    result?.setValue(result?.recordID.recordName, forKey: "id")
                    musicianRecord!.setValue(CKRecord.Reference(record: result!,action: .none), forKey: "band")
                    let modifierOperation = CKModifyRecordsOperation(recordsToSave: [musicianRecord!, result!], recordIDsToDelete: [])
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
                }
            })
        }
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
    
    func createSong(song: Song,by musician: Musician, on band:Band, completionHandler: @escaping (Error?)->Void){
        let songRecord = CKRecord(recordType:"Song")
        var musicianRecord = CKRecord(recordType:"Musician")
        var bandRecord = CKRecord(recordType:"Band")
        queryBand(id: band.id!) { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(error)
                return
            } else {
                bandRecord = record!
                self.queryMusician(id: musician.id!) { (musicianRec, err) in
                    if err != nil {
                        print(err?.localizedDescription as Any)
                        completionHandler(err)
                        return
                    }
                    guard let musicianRec = musicianRec else {return}
                    musicianRecord = musicianRec
                    songRecord.setValue(song.name, forKey: "name")
                    let musicianReference = CKRecord.Reference(record: musicianRecord, action: .none)
                    songRecord.setValue(musicianReference, forKey: "creator")
//                    guard var bandRepertoire = bandRecord["repertoire"] as? [CKRecord.Reference] else {
//                        //repertoire vazio
//                        return
//                    }
                    var bandRepertoire: [CKRecord.Reference]
                    if let repertoire = bandRecord["repertoire"] as? [CKRecord.Reference] {
                        //repertoire tem musicas
                        bandRepertoire = repertoire
                    } else {
                        //repertoire nao tem musicas
                        bandRepertoire = []
                    }
                    self.database?.save(songRecord, completionHandler: { (savedSongRecord, songError) in
                        if songError != nil {
                            print(songError?.localizedDescription as Any)
                            completionHandler(songError)
                            return
                        }
                        guard let savedSongRecord = savedSongRecord else {return}
                        bandRepertoire.append(CKRecord.Reference(record: savedSongRecord, action: .none))
                        bandRecord.setValue(bandRepertoire, forKey: "repertoire")
                        let modifierOperation = CKModifyRecordsOperation(recordsToSave: [bandRecord], recordIDsToDelete: [])
                        modifierOperation.modifyRecordsCompletionBlock = { _,_,modifyError in
                            guard modifyError == nil else {
                                guard let cloudError = modifyError as? CKError else {
                                    completionHandler(error)
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
        }
    }
    
    

    

    
    //MARK: Insert Function
    func insert(song:Song,on setlist:Setlist,of band:Band, completionHandler: @escaping (CKRecord?,Error?)->Void){
        var songRecord = CKRecord(recordType:"Song")
        var setlistRecord = CKRecord(recordType:"Setlist")
        var bandRecord = CKRecord(recordType:"Band")
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
                        songRecord = CKRecord(recordType:"Song", recordID: searchingSong.recordID)
                    }
                }
    
                for searchingSetlist in bandRecord.value(forKey: "setlists") as! [CKRecord.Reference]{
                    if searchingSetlist.recordID == setlistRecord.recordID {
                        setlistRecord = CKRecord(recordType:"Setlist", recordID: searchingSetlist.recordID)
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
        var musicianRecord = CKRecord(recordType:"Musician")
        var bandRecord = CKRecord(recordType:"Band")
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
                        musicianRecord = CKRecord(recordType:"Musician", recordID: searchingMusician.recordID)
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
    
    
    //MARK: QueryAll Functions
    func queryAllSongs(from band:Band, songsReferences: Any?, completionHandler: @escaping(Error?)->Void){
        if let allSongsID = songsReferences as? [CKRecord.Reference] {
        var bandSongs = allSongsID
        for i in 0..<allSongsID.count {
            //Ve se os membros estao no allReferenced
            print("Songs ->name do record do song:",allSongsID[i].recordID.recordName)
            print("dicionario de bandas")
            for (key,value) in Band.allReferenced {
                print("\tkey: \(key) \n\tvalue: \(value)")
            }
            print("dicionario de musicos")
            for (key,value) in Song.allReferenced {
                print("\tkey: \(key) \n\tvalue: \(value)")
            }
            //            Se sim
            if let song = Song.allReferenced[allSongsID[i].recordID.recordName] {
                //adiciona na banda
                band.repertoire.append(song)
                print("nome do member \(song.name)")
                //retira do vetor
                bandSongs.remove(at: i)
            }
        }
            if bandSongs.count == 0 {
                completionHandler(nil)
                return
            }
        }
        //pega do icloud
        guard let bandID = band.id else {return}
        DAO.queryBand(id: bandID) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(error)
                return
            }
            guard let bandRecord = result else {return}
            guard let bandRepertoire = bandRecord.value(forKey: "repertoire") as? [CKRecord.Reference] else {return}
            print(bandRepertoire)
            for songReference in bandRepertoire {
                DAO.fetchRecord(from: songReference, completionHandler: { (returnedRecord, fetchError) in
                    if fetchError != nil {
                        print(fetchError?.localizedDescription as Any)
                        completionHandler(fetchError)
                    } else {
                        guard let songRecord = returnedRecord else {return}
                        let songDict = songRecord.asDictionary
                        Song.asynchronousCreation(from: songDict, completionHandler: { (returnedSong, creationError) in
                            if creationError != nil {
                                print(creationError?.localizedDescription as Any)
                                completionHandler(creationError)
                            }
                            guard let realSong = returnedSong else {return}
                            band.repertoire.append(realSong)
                            completionHandler(nil)
                        })
                    }
                })
            }
        }
    }
    
    func queryAllSetlists(from band:Band, with setlistsReference: Any = [], completionHandler: @escaping(Error?)->Void){
        let allSetlistsID = setlistsReference as! [CKRecord.Reference]
        var bandSetlists = allSetlistsID
        for i in 0..<allSetlistsID.count {
            //Ve se os membros estao no allReferenced
            print("Setlists -> name do record do setlist:",allSetlistsID[i].recordID.recordName)
            print("dicionario de bandas")
            for (key,value) in Band.allReferenced {
                print("\tkey: \(key) \n\tvalue: \(value)")
            }
            print("dicionario de musicos")
            for (key,value) in Setlist.allReferenced {
                print("\tkey: \(key) \n\tvalue: \(value)")
            }
            //            Se sim
            if let setlist = Setlist.allReferenced[allSetlistsID[i].recordID.recordName] {
                //adiciona na banda
                band.setlists.append(setlist)
                print("nome do member \(setlist.name)")
                //retira do vetor
                bandSetlists.remove(at: i)
            }
        }
        if bandSetlists.count == 0 {
            completionHandler(nil)
            return
        }
        
        //pega do icloud
        guard let bandID = band.id else {return}
        DAO.queryBand(id: bandID) { (result, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(error)
                return
            }
            guard let bandRecord = result else {return}
            let bandRepertoire = bandRecord.value(forKey: "setlists") as? [CKRecord.Reference]
            for setlistReference in bandRepertoire! {
                DAO.fetchRecord(from: setlistReference, completionHandler: { (setlistRecord, recordError) in
                    if recordError != nil {
                        print(recordError?.localizedDescription as Any)
                        completionHandler(recordError)
                    }

                })
//                let setlist = Setlist(asDictionary: setlistReference.asSetlistDictionary)
//                band.setlists.append(setlist)
            }
            completionHandler(nil)
        }
    }
    
    
    func queryAllMusicians(from band:Band, with membersReferences: Any?, completionHandler: @escaping(Error?)->Void){
        //O vetor de members
        if let allMembersID = membersReferences as? [CKRecord.Reference] {
            var bandMembers = allMembersID
            for i in 0..<allMembersID.count {
                //Ve se os membros estao no allReferenced
                print("Musicians -> name do record do member:",allMembersID[i].recordID.recordName)
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
            if bandMembers.count == 0 {
                completionHandler(nil)
                return
            }
        }
        //os que sobraram
        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(format: "band == %@", CKRecord.ID(recordName: band.id!)))
        //pega do icloud/dando erro/sendo chamada duas vezes
        print("indo ate aqui")
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (results, error) in
            if error != nil {
                print("deu erro")
                print(error?.localizedDescription as Any)
                completionHandler(error)
            } else {
                guard let results = results else {return}
                for musician in results {
                        // e um elemento de um nsarray
                        Musician.asynchronousCreation(from: musician.asDictionary, completionHandler: { (fetchedMusician, error) in
                            if error != nil {
                                completionHandler(nil)
                            }
                            guard let member = fetchedMusician else {return}
                            band.members.append(member)
                        })
                completionHandler(nil)
                }
            }
            return
        })
    }
//
//    func queryAllEvents(from band: Band, with eventsReferences: Any, completionHandler: @escaping (Error?)->Void){
//        //O vetor de members
//        let allEventsID = eventsReferences as! [CKRecord.Reference]
//        var bandEvents = allEventsID
//        for i in 0..<allEventsID.count {
//            //Ve se os membros estao no allReferenced
//            print("name do record do member:",allEventsID[i].recordID.recordName)
//            print("dicionario de bandas")
//            for (key,value) in Band.allReferenced {
//                print("\tkey: \(key) \n\tvalue: \(value)")
//            }
//            print("dicionario de musicos")
//            for (key,value) in Musician.allReferenced {
//                print("\tkey: \(key) \n\tvalue: \(value)")
//            }
//            //            Se sim
//            if let event = Event.allReferenced[allEventsID[i].recordID.recordName] {
//                //adiciona na banda
//                band.events.append(event)
//                print("nome do member \(event.name)")
//                //retira do vetor
//                bandEvents.remove(at: i)
//            }
//        }
//        if bandEvents.count == 0 {
//            completionHandler(nil)
//            return
//        }
//        //os que sobraram
//        guard let bandID = band.id else {return}
//
//        DAO.queryBand(id: bandID) { (result, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                completionHandler(error)
//                return
//            }
//            guard let bandRecord = result else {return}
//            let bandEvents = bandRecord.value(forKey: "events") as? [CKRecord.Reference]
//            for eventReference in bandEvents! {
//                let event = Event(asDictionary: eventReference.asDictionary)
//                band.events.append(event)
//            }
//            completionHandler(nil)
//        }
//    }
    
    
    
    //MARK: Query Functions
    
    func queryBand(id: String, completionHandler: @escaping(CKRecord?,Error?)->Void){
        let query = CKQuery(recordType:"Band", predicate: NSPredicate(value: true))
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
        let query = CKQuery(recordType:"Musician", predicate: NSPredicate(format: "id == %@", id))
//        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(value: true))
        print(query)
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
    func fetchCurrentUser(completionHandler: @escaping(Musician?,Error?)->Void){
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
                            self.userHasLogged = false
                            completionHandler(nil,nil)
                        } else {
                            // Usuario ja Existe
                            print("record existe")
                            guard let userDict = userRecord?.asDictionary else {return}
//                            var user: Musician
                            let userName = userDict["name"] as! String
                            let userAge = userDict["age"] as! Int
                            let instrumentsString = userDict["instruments"] as! [String]
                            var instruments: [Instrument] = []
                            for instrument in instrumentsString {
                                instruments.append(instrument.asInstrument)
                            }
                            let userInstruments = instruments
                            guard let userID = userDict["id"] as? String else {return}
                            guard let userRecordName = userDict["musicianRecordName"] as? String else {return}
                            if let bandReference = userDict["band"] as? CKRecord.Reference {
                                DAO.fetchBand2(with: bandReference.recordID.recordName) { [weak self] (band, error) in //tenho a banda
                                    if error != nil {
                                        print(error?.localizedDescription as Any)
                                        completionHandler(nil,error)
                                        return
                                    }
                                    guard let band = band else {return}
                                    let musician = Musician(name: userName, age: userAge, instruments: userInstruments, band: band, id: userID, musicianRecordName: userRecordName)
                                    SessionManager.currentUser = musician
                                    SessionManager.currentBand = band
                                    self!.userHasLogged = true
                                    completionHandler(musician,nil)
                                }
                            } else {
                                let musician = Musician(name: userName, age: userAge, instruments: userInstruments, band: nil, id: userID,  musicianRecordName: userRecordName)
                                completionHandler(musician,nil)
                            }
                        }
                    }
                })
            }
        }
    }
    
    func fetchMusician(id: String, completionHandler: @escaping(Musician?,Error?)->Void){
        let query = CKQuery(recordType: "Musician", predicate: NSPredicate(format:"musicianRecordName == %@", id))
        print("fetch musician query",query)
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (userRecords, error) in
            
//        })
//        self.queryMusician(id: id, completionHandler: { (userRecord, error) in
            if error != nil {
                print(error!.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                if userRecords == nil {
                    //Usuario nao existe
                    print("Usuario nao Existe")
                    self.userHasLogged = false
                    completionHandler(nil,nil)
                } else {
                    // Usuario ja Existe
                    print("record existe")
                    let userDict = userRecords![0].asDictionary
                    //                            var user: Musician
                    let userName = userDict["name"] as! String
                    let userAge = userDict["age"] as! Int
                    let instrumentsString = userDict["instruments"] as! [String]
                    var instruments: [Instrument] = []
                    for instrument in instrumentsString {
                        instruments.append(instrument.asInstrument)
                    }
                    let userInstruments = instruments
                    guard let userID = userDict["id"] as? String else {return}
                    guard let userRecordName = userDict["musicianRecordName"] as? String else {return}
                    if let bandReference = userDict["band"] as? CKRecord.Reference {
                        DAO.fetchBand2(with: bandReference.recordID.recordName) { (band, error) in //tenho a banda
                            if error != nil {
                                print(error?.localizedDescription as Any)
                                completionHandler(nil,error)
                            }
                            guard let band = band else {return}
                            let musician = Musician(name: userName, age: userAge, instruments: userInstruments, band: band, id: userID, musicianRecordName: userRecordName)
                            completionHandler(musician,nil)
                        }
                    }
                }
            }
        })
    }
    
    func fetchRecord(from reference: CKRecord.Reference, completionHandler: @escaping(CKRecord?,Error?)->Void){
        DAO.database?.fetch(withRecordID: reference.recordID, completionHandler: { (record, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            }
            completionHandler(record,error)
        })
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
    
    func oldFetchBand(with id:String, completionHandler: @escaping(CKRecord?,Error?)-> Void){
        let recordID = CKRecord.ID(recordName: id)
        print("fetching band")
        DAO.database?.fetch(withRecordID: recordID, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
                return
            }
            guard let bandRecord = result else {
                completionHandler(nil,nil)
                return
            }
            
            let bandDict = bandRecord.asDictionary

            let band = Band()
            if let name = bandDict["name"] as? String {
                band.name = name
            }
            band.id = bandDict["id"] as? String
            let bandRepertoire: [Song] = []
            
            if let repertoireReference = bandDict["repertoire"] as? [CKRecord.Reference] {
                DAO.queryAllSongs(from: band, songsReferences: repertoireReference, completionHandler: { (songsError) in
                    if songsError != nil {
                        print(songsError?.localizedDescription as Any)
                        completionHandler(nil,songsError)
                        return
                    }
                    if let membersReference = bandDict["members"] as? [CKRecord.Reference] {
                        DAO.queryAllMusicians(from: band, with: membersReference, completionHandler: { (membersError) in
                            if membersError != nil {
                                print(songsError?.localizedDescription as Any)
                                completionHandler(nil,membersError)
                                return
                            }
                            if let setlistReference = bandDict["setlists"] as? [CKRecord.Reference] {
                                DAO.queryAllSetlists(from: band, with: setlistReference, completionHandler: { (setlistError) in
                                    if setlistError != nil {
                                        print(setlistError?.localizedDescription as Any)
                                        completionHandler(nil,setlistError)
                                        return
                                    }
                                })
                            } else {
                                band.setlists = []
                            }
                        })
                    } else {
                        band.members = []
                    }
                    
                })
            } else {
                band.repertoire = []
            }
            completionHandler(bandRecord,error)
        })
    }
    
    //SENDO RECHAMADA VARIAS VEZES
    func fetchBand2(with id:String, completionHandler: @escaping (Band?,Error?)-> Void){
        print("fetching band")
        let query = CKQuery(recordType: "Band", predicate: NSPredicate(format: "id == %@", id))
        DAO.database?.perform(query, inZoneWith: nil, completionHandler: { (records, error) in
            if error != nil {
                completionHandler(nil,error)
                return
            }
            
//            guard let bandRecord = record else {
//                completionHandler(nil,nil)
//                return
//            }`
            guard let records = records else {
                completionHandler(nil,nil)
                return
            }
            
            let bandRecord = records[0]
            
            let dict = bandRecord.asDictionary
            
            let band = Band()
            
            if let name = dict["name"] as? String {
                band.name = name
                print(band.name)
            }
            
            band.id = dict["id"] as? String
            
            completionHandler(band,nil)
        })
    }
//            var hasMembers = false, hasSongs = false, hasSetlists = false
//            if dict["members"] != nil {hasMembers = true}
//            if dict["repertoire"] != nil {hasSongs = true}
//            if dict["setlists"] != nil {hasSetlists = true}
            
//            if hasMembers {
//                DAO.queryAllMusicians(from: band, with: dict["members"]!, completionHandler: { (membersError) in
//                    if membersError != nil {
//                        print(membersError?.localizedDescription as Any)
//                        completionHandler(nil,membersError)
//                        return
//                    }
//                    if hasSongs {
//                        DAO.queryAllSongs(from: band, songsReferences: dict["repertoire"]!, completionHandler: { (songsError) in
//                            if songsError != nil {
//                                print(songsError?.localizedDescription as Any)
//                                completionHandler(nil,songsError)
//                                return
//                            }
//                            if hasSetlists {
//                                DAO.queryAllSetlists(from: band, with: dict["setlists"]!, completionHandler: { (setlistsError) in
//                                    if setlistsError != nil {
//                                        print(setlistsError?.localizedDescription as Any)
//                                        completionHandler(nil,setlistsError)
//                                        return
//                                    }
//                                    completionHandler(band,nil)
//                                })
//                            } else {
//                                band.setlists = []
//                                completionHandler(band,nil)
//                            }
//                        })
//                    } else {
//                        band.repertoire = []
//                        if hasSetlists {
//                            DAO.queryAllSetlists(from: band, with: dict["setlists"]!, completionHandler: { (setlistsError) in
//                                if setlistsError != nil {
//                                    print(setlistsError?.localizedDescription as Any)
//                                    completionHandler(nil,setlistsError)
//                                    return
//                                }
//                                completionHandler(band,nil)
//                                return
//                            })
//                        } else {
//                            band.setlists = []
//                            completionHandler(band,nil)
//                        }
//                    }
//                })
          
    
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
