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
    
    init(name: String, songs: [Song], id: String?) {
        self.name = name
        self.songs = songs
        super.init(id: id!)
    }
    
    required init(asDictionary: [String : Any]) {
        fatalError("init(asDictionary:) has not been implemented")
    }
}
