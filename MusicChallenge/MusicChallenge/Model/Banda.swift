//
//  Banda.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class Banda {
    var membros: [Musico]
    var repertorio: [Musica]
    
    init(membros: [Musico], repertorio: [Musica]) {
        self.membros = membros
        self.repertorio = repertorio
    }
}
