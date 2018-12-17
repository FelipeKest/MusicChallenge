//
//  Musico.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import CloudKit

class Musico:Saveable,Loadable {

    var id: String?
    
    var asDictionary: [String : Any] {
        var result:[String:Any] = [:]
        // TODO: Implementar
        result["nome"] = self.nome
        result["idade"] = self.idade
        result["instrumentos"] = instrumentos.idsAsString
        result["bandaID"] = self.bandReference
        return result
    }
    
    var nome: String
    var idade: Int
    var instrumentos: [Instrumento]
    let bandReference: CKRecord.Reference
    
    init(nome: String, idade: Int, instrumentos: [Instrumento], bandReference: CKRecord.Reference) {
        self.nome = nome
        self.idade = idade
        self.instrumentos = instrumentos
        self.bandReference = bandReference
    }
    
    required convenience init(asDictionary: [String : Any]) {
        self.nome = asDictionary["nome"] as! String
        self.idade = asDictionary["idade"] as! Int
        self.instrumentos = asDictionary["instrumentos"] as! [Instrumento]
    }
    
}
