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
    
    init(type: InstrumentTypes, id: String){
        self.type = type
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.type = asDictionary["type"] as! InstrumentTypes
        super.init(asDictionary: asDictionary)
    }
}
