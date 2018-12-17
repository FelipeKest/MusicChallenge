//
//  Musica.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

class Musica:Saveable, Loadable {
    
    var id: String?
    
    var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["nome"] = self.nome
        result["instrumentos"] = self.instrumentos.idsAsString
        result["bandaID"] = self.bandaId
    }
    
    var nome: String
    var instrumentos: [Instrumento]
    var bandaId: CKRecord.Reference
    
    init(nome: String, instrumentos: [Instrumento]) {
        self.nome = nome
        self.instrumentos = instrumentos
    }
    
    
    required convenience init(asDictionary: [String : Any]) {
        self.nome = asDictionary["nome"] as! String
        self.instrumentos = asDictionary["instrumentos"] as! [Instrumento]
        
    }
}
