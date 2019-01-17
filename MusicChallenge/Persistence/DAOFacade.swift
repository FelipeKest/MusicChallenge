//
//  DAOFacade.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 17/01/19.
//  Copyright © 2019 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

let DAOFacade = daofacade.instance

class daofacade {
    static let instance = daofacade()
    
    private init(){
        
    }
    
    func load(band: Band, from dict:[String:Any], completionHandler: @escaping(Band?,Error?)->Void){
        let bandName = dict["name"]
        var bandMusicians:[Musician] = []
        var bandSongs:[Song] = []
        var bandSetlists:[Setlist] = []
        if let membersID = dict["members"] {
            DAO.queryAllMusicians(from: band, and: membersID) { (membersError) in
                
            }
        }
    }
}
