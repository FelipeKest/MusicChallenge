//
//  Playlist.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 13/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Playlist:Saveable {
    var id: String?
    
    var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["nome"] = self.name
        result["musicas"] = musicas.idsAsString
    }
    
    var name: String
    var musicas: [Musica]
    
    init(name: String, musicas: [Musica]) {
        self.name = name
        self.musicas = musicas
    }
}
