//
//  SessionManager.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 20/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

let SessionManager = sessionManager.instance

class sessionManager {
    static let instance = sessionManager()
    public var currentUserID: String?
    public var currentUser: CKRecord?
    private var currentBandID: String = ""
    
    
    func getCurrentUser(completionHandler: @escaping(CKRecord?,Error?)->Void){
        DAO.fetchCurrentUser { (userRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                print("error in session manager")
                completionHandler(nil,error)
                return
            } else {
                if let userRecord = userRecord {
                    self.currentUser = userRecord
                    completionHandler(userRecord,error)
                    print("recuperei musico ja criado")
                } else {
                    print("erro recuperando userID")
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
}
