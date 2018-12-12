//
//  Musica.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class Musica {
    var nome: String
    var instrumentos: [Instrumento]
    
    init(nome: String, instrumentos: [Instrumento]) {
        self.nome = nome
        self.instrumentos = instrumentos
    }
}
