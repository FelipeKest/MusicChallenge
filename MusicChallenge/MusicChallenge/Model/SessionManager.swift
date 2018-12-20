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
    private var currentUserID: String = ""
    private var currentBandID: String = ""
    
    func getCurrentUserID(completionHandler: @escaping(String?,Error?)->Void){
        var id: String = ""
        DAO.fetchCurrentUser { (userRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                id = (userRecord?.recordID.recordName)!
                completionHandler(id,nil)
            }
        }
    }
    
    
    func getCurrentUserBandID(completionHandler: @escaping(String?,Error?)->Void){
        var bandID: String = ""
        DAO.fetchCurrentUserBand { (bandRecord, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                bandID = (bandRecord?.recordID.recordName)!
                completionHandler(bandID,error)
            }
        }
    }
    
    
    private init (){
        getCurrentUserID { (userID, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            } else {
                self.currentUserID = userID!
            }
        }
        getCurrentUserBandID { (bandID, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            } else {
                self.currentBandID = bandID!
            }
        }
    }
}
