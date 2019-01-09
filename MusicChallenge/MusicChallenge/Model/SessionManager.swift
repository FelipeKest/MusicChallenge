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

let SessionManager = sessionManager.instance

class sessionManager: LoginManager {
    static let instance = sessionManager()
    public var currentUserID: String?
    public var currentUser: Musician?
    public var currentBandID: String?
    
    private init (){
        //        getCurrentUserBandID(userRecord: CKRecord(recordType: "Users", recordID: CKRecord.ID(recordName: self.currentUserID))) { (bandID, error) in
        //            if error != nil {
        //                print(error?.localizedDescription as Any)
        //                return
        //            } else {
        //                self.currentBandID = bandID!
        //            }
        //        }
    }

    
    
    func getCurrentUser(completionHandler: @escaping(Musician?,Error?)->Void){
        DAO.fetchCurrentUser { (userRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                print("error in session manager")
                completionHandler(nil,error)
                return
            } else {
                if let userRecord = userRecord {
                    self.currentUserID = userRecord.recordID.recordName
                    self.currentBandID = userRecord.value(forKey: "bandID") as? String
                    let musicianUser = userRecord.asMusician// Musician(asDictionary: userRecord.asDictionary)
                    self.currentUser = musicianUser
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
    
    
    

