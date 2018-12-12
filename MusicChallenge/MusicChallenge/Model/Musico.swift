//
//  Musico.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class Musico {
    var nome: String
    var idade: Int
    var instrumentos: [Instrumento]
    
    init(nome: String, idade: Int, instrumentos: [Instrumento]) {
        self.nome = nome
        self.idade = idade
        self.instrumentos = instrumentos
    }
}
