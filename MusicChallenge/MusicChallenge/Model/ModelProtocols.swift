//
//  ModelProtocols.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 14/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

protocol Saveable {
    var id:String? {get set}
    var asDictionary:[String:Any] {get}
}

protocol Loadable {
    init(asDictionary:[String:Any])
    //Instancia
    
}
