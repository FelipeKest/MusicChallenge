//
//  instrument.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class Instrument:GenericProtocolClass{
    var type: InstrumentTypes
    var player: Musician?
    
    init(type: InstrumentTypes, id: String, player: Musician?){
        self.type = type
        self.player = player
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.type = asDictionary["type"] as! InstrumentTypes
        super.init(asDictionary: asDictionary)
    }
    
    init(typeName: String) {
        switch typeName {
        case "Bass":
            self.type = .Bass
            super.init(id: "")
        case "Guitar":
            self.type = .Guitar
            super.init(id: "")
        case "Drums":
            self.type = .Drums
            super.init(id: "")
        case "Singer":
            self.type = .Singer
            super.init(id: "")
        case "Others":
            self.type = .Others
            super.init(id: "")
        default:
            self.type = .Others
            super.init(id: "")
        }
    }
}
