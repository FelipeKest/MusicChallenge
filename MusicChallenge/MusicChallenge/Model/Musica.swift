//
//  Musica.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

class Musica {
    var nome: String
    var instrumentos: [String]
    var musicaId: CKRecord.ID?
    
    init(nome: String, instrumentos: [String]) {
        self.nome = nome
        self.instrumentos = instrumentos
    }
}
