//
//  Band.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Band:GenericProtocolClass {
    var members:[Musician] = []
    var repertoire: [Song] = []
    var setlists:[Setlist] = []
    var events:[Event] = []
    
    override var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["members"] = self.members
        result["repertoire"] = self.repertoire
        result["setlist"] = self.setlists
        result["events"] = self.events
        return result
    }
}




