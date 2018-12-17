//
//  Banda.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Banda:Saveable {
    var id:String?
    var integrantes:[Musico] = []
    var repertorio: [Musica] = []
    var setList:[Playlist] = []
    
    var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["integrantes"] = integrantes.idsAsString
        
        
        return result
    }
}




