//
//  GenericProtocolClassCloud.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class GenericProtocolClass: Saveable,Loadable {
   
    var id: String?
    
    var asDictionary: [String : Any] {
        var result:[String:Any] = [:]
        result["id"] = self.id
        return result
    }
    
    required init(asDictionary: [String : Any]) {
        self.id = asDictionary["id"] as! String?
    }
    
    init(id: String?){
        self.id = id
    }
}

