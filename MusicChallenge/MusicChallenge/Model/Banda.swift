//
//  Banda.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

class Banda {
    var repertorio: [Musica]
    let zone: CKRecordZone
    
    init(repertorio: [Musica], zone: CKRecordZone) {
        self.repertorio = repertorio
        self.zone = zone
    }
    
}
