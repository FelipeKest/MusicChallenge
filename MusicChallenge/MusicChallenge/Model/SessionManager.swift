//
//  SessionManager.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 20/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

typealias MusicianCompletion = (Musician?,Error?)->Void
let SessionManager = sessionManager.instance

class sessionManager {
    var userHasLoged: Bool?
    static let instance = sessionManager()
    public var currentUserID: String?
    public var currentUser: Musician?
    public var currentBandID: String?
    
    
    private init (){
        
    }

    func getCurrentUser(completionHandler: @escaping(MusicianCompletion)){
        DAO.fetchCurrentUser { (user, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                print("error in session manager")
                completionHandler(nil,error)
                return
            } else {
                if let user = user {
//                    self.currentBandID = userRecord.value(forKey: "bandID") as? String
                    let musicianUser = user// Musician(asDictionary: userRecord.asDictionary)
                    SessionManager.currentUser = musicianUser
                    completionHandler(musicianUser,nil)
                    print("recuperei musico ja criado")
                } else {
                    print("erro recuperando userID")
                    completionHandler(nil,nil)
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
    
    
    

