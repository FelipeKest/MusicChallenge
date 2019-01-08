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
    var creator: Musician
//    var band: Band
//    var setlists: [Setlist]

    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instruments"] = self.instruments.instrumentsAsString
        result["creator"] = self.creator
//        result["bandID"] = self.band
//        result["setlists"] = self.setlists
        return result
    }
    
//    init(name: String, instruments: [Instrument] = [], creator: Musician, setlists: [Setlist] = [],band: Band, id: String) {
//        self.name = name
//        self.instruments = instruments
//        self.creator = creator
//        self.band = band
//        self.setlists = setlists
//        super.init(id: id)
//    }
    
    init(name: String, instruments: [Instrument] = [], creator: Musician, id: String) {
        self.name = name
        self.instruments = instruments
        self.creator = creator
//        self.setlists = setlists
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.instruments = asDictionary["instruments"] as! [Instrument]
        self.creator = asDictionary["creatorID"] as! Musician
//        self.setlists = asDictionary["setlists"] as! [Setlist]
//        self.band = asDictionary["bandID"] as! Band
        super.init(id: asDictionary["id"] as? String)
    }
    
    convenience init() {
        self.init(name: "Convenience Song", creator: Musician(), id: "Convenience Id")
    }
    
}
