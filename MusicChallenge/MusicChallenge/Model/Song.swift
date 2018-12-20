//
//  Song.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Song:GenericProtocolClass {
    
    var name: String
    var instruments: [Instrument]
    var creator: String
    var bandID: String
    var setlistsIn: [Setlist]

    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instruments"] = self.instruments.instrumentsAsString
        result["creator"] = self.creator
        result["bandID"] = self.bandID
        result["setlists"] = self.setlistsIn
        return result
    }
    
    init(name: String, instruments: [Instrument] = [], creatorID: String, setlists: [Setlist] = [],bandID: String, id: String) {
        self.name = name
        self.instruments = instruments
        self.creator = creatorID
        self.bandID = bandID
        self.setlistsIn = setlists
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.instruments = asDictionary["instruments"] as! [Instrument]
        self.creator = asDictionary["creatorID"] as! String
        self.setlistsIn = asDictionary["setlists"] as! [Setlist]
        self.bandID = asDictionary["bandID"] as! String
        super.init(id: asDictionary["id"] as? String)
    }
    
    convenience init() {
        self.init(name: "Convenience Song", creatorID: "Convenience Creator", bandID: "Convenience Band", id: "Convenience Id")
    }
    
}
