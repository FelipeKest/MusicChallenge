//
//  Musico.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

class Musico {
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
    
}
