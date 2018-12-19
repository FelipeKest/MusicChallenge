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
    var bandID: String

    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instruments"] = self.instruments.instrumentsAsString
//        result["bandID"] = self.bandId
        return result
    }
    
    init(name: String, instruments: [Instrument],bandID: String,id:String) {
        self.name = name
        self.instruments = instruments
        self.bandID = bandID
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.instruments = asDictionary["instruments"] as! [Instrument]
        self.bandID = asDictionary["bandID"] as! String
        super.init(id: asDictionary["id"] as? String)
    }
    
    convenience init() {
        self.init(name: "Convenience", instruments: [Instrument(type: InstrumentTypes.Bass, id: "")], bandID: "ConvenienceBand",id: "Convinience")
    }
    
}
