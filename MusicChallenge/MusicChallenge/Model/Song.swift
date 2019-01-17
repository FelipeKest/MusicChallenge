//
//  Song.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Song:GenericProtocolClass {
    
    var name: String
    var musicians: [SongMusician]
    var creator: Musician
    
    static var allReferenced:[String:Song] = [:]
//    var band: Band
//    var setlists: [Setlist]

    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instruments"] = self.musicians
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
    
    init(name: String, instruments: [SongMusician] = [SongMusician()], creator: Musician = Musician(), id: String = "") {
        self.name = name
        self.musicians = instruments
        self.creator = creator
//        self.setlists = setlists
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.musicians = asDictionary["instruments"] as! [SongMusician]
        self.creator = asDictionary["creatorID"] as! Musician
//        self.setlists = asDictionary["setlists"] as! [Setlist]
//        self.band = asDictionary["bandID"] as! Band
        super.init(id: asDictionary["id"] as? String)
    }
    
    convenience init() {
        self.init(name: "Convenience Song", creator: Musician(), id: "Convenience Id")
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}

class SongMusician {
    var musician: Musician?
    var instrument: Instrument?
    
    init(from string: String){
        let musicianTxt = string.split(separator: "|")[0]
        let instrumentTxt = string.split(separator: "|")[1]
        self.instrument = String(instrumentTxt).asInstrument
        for musician in Musician.allReferenced {
            if musician.key == musicianTxt {
                self.musician = musician.value
            }
        }
    }
    convenience init(){
        self.init(from: "DA0A1DE1-9654-4338-8C27-A3BE52B23C5E|Bass")
    }
}
