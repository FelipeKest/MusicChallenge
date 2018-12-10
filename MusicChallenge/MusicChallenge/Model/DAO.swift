//
//  DAO.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

let DAO = dao.instance

class dao{
    static let instance = dao()
    
    var database: CKDatabase?
    
}
