//
//  DAO.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

let dao = DAO.instance

protocol CurrentUserObserver {
    func currentUserChanged()
}

class DAO{
    static let instance = DAO()
    var currenUserObserver: CurrentUserObserver?
    
    var currentUser:Musician {
        didSet {
            currenUserObserver?.currentUserChanged()
        }
    }
    
    init() {
        let instruments = [Instrument(type: .Guitar, id: "Guitar"),
                           Instrument(type: .Bass, id: "Bass"),
                           Instrument(type: .Drums, id: "Drums"),]
        
        let band = Band(name: "OsPaunoCU", members: [], repertoire: [], setlists: [], events: [], id: "Band")
        
        
        let musicians = [Musician(name: "Lucas", age: 24, instruments: instruments, band: band, id: "Lucas"),
                         Musician(name: "Guilherme", age: 24, instruments: instruments, band: band, id: "band")]
        
        band.members = musicians
        self.currentUser = musicians[0]
    }
    
    
    


    
}
