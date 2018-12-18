//
//  Events.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 17/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

class Event:GenericProtocolClass {
    var name: String
    var location: String
    var date: Date
    var time: Date
    var associatedSetlist: Setlist
    
    
    init(name:String,place:String,date: Date,time: Date,setlist:Setlist,id: String?) {
        self.name = name
        self.location = place
        self.date = date
        self.time = time
        self.associatedSetlist = setlist
        super.init(id: id!)
    }
    
    required init(asDictionary: [String : Any]) {
        
        fatalError("init(asDictionary:) has not been implemented")
    }
}
