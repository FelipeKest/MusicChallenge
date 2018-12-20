//
//  Setlist.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 13/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Setlist:GenericProtocolClass {
    
    var name: String
    var songs: [Song]
    var creator: String
    var bandID: String
    
    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["songs"] = self.songs
        result["creator"] = self.creator
        result["bandID"] = self.bandID
        return result
    }
    
    init(name: String, songs: [Song],creator:String, bandID:String, id: String) {
        self.name = name
        self.songs = songs
        self.creator = creator
        self.bandID = bandID
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.songs = asDictionary["songs"] as! [Song]
        self.bandID = asDictionary["bandID"] as! String
        self.creator = asDictionary["creatorID"] as! String
        super.init(id: asDictionary["id"] as? String)
    }
}
