//
//  Musico.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Musician:GenericProtocolClass {

    var name: String
    var age: Int
    var instruments: [Instrument]?
    var band: Band?
    
    init(name: String, age: Int, instruments: [Instrument]?, band: Band,id: String?) {
        self.name = name
        self.age = age
        self.instruments = instruments
        self.band = band
        super.init(id: id)
    }
    
    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["age"] = self.age
        result["instruments"] = self.instruments
        result["band"] = self.band
        result["id"] = super.id
        return result
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.age = asDictionary["age"] as! Int
        self.instruments = asDictionary["instruments"] as? [Instrument]
        self.band = asDictionary["bandID"] as! Band?
        super.init(asDictionary: asDictionary)
    }
    
    convenience init (){
        self.init(name: "Convenience Musician", age: 0, instruments: [], band: Band(), id: "Convenience")
    }
}
