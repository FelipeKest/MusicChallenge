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
    var bandId: String
    
    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instrument"] = self.instruments
        result["bandID"] = self.bandId
        return result
    }
    
    init(name: String, instruments: [Instrument],bandId:String,id:String?) {
        self.name = name
        self.instruments = instruments
        self.bandId = bandId
        super.init(id: id!)
    }
    
    required init(asDictionary: [String : Any]) {
        fatalError("init(asDictionary:) has not been implemented")
    }
    
    convenience init() {
        self.init(name: "Convenience", instruments: [], bandId: "Convenience", id: "Convinience")
    }
    
    
}
