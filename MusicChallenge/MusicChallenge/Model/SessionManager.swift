//
//  SessionManager.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 20/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

protocol LoginManager {
    func getCurrentUser(completionHandler: @escaping(Musician?,Error?)->Void)
}

typealias MusicianCompletion = (Musician?,Error?)->Void
let SessionManager = sessionManager.instance

class sessionManager: LoginManager {
    var userHasLoged: Bool?
    static let instance = sessionManager()
    public var currentUserID: String?
    public var currentUser: Musician?
    
//    public var currentBandID: String?
    
    private init (){
        getCurrentUser { (musician, error) in
            if error != nil {
                return
            }
            if let musician = musician {
                self.currentUser = musician
            }
        }
    }

    
    
    func getCurrentUser(completionHandler: @escaping(MusicianCompletion)){
        DAO.fetchCurrentUser { (userRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                print("error in session manager")
                completionHandler(nil,error)
                return
            } else {
                if let userRecord = userRecord {
//                    self.currentBandID = userRecord.value(forKey: "bandID") as? String
                    let musicianUser = userRecord.asMusician// Musician(asDictionary: userRecord.asDictionary)
                    completionHandler(musicianUser,error)
                    print("recuperei musico ja criado")
                } else {
                    print("erro recuperando userID")
                }
            }
        }
    }
    
    
}
    
    
//    func getCurrentUserBandID(userRecord: CKRecord,completionHandler: @escaping(String?,Error?)->Void){
//        var bandID: String = ""
//        DAO.fetchBand(for: userRecord, completionHandler: { (result, error) in
//            if error != nil {
//                print(error?.localizedDescription as Any)
//                return
//            } else {
//                bandID = result!["id"]!
//                completionHandler(bandID,nil)
//            }
//        })
//    }
    
    
    

