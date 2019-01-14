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
    var associatedSetlist: Setlist?
    var bandID: String
    var eventType: EventTypes
    
    
    init(name:String,place:String,date: Date,setlist:Setlist? = nil,bandID: String,id: String?,eventType: EventTypes = EventTypes.Rehearsal) {
        self.name = name
        self.location = place
        self.date = date
        self.associatedSetlist = setlist
        self.bandID = bandID
        self.eventType = eventType
        super.init(id: id!)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.location = asDictionary["location"] as! String
        self.date = asDictionary["date"] as! Date
        self.associatedSetlist = asDictionary["associatedSetlist"] as? Setlist
        self.bandID = asDictionary["bandID"] as! String
        self.eventType = asDictionary["eventType"] as! EventTypes
        super.init(id: asDictionary["id"] as? String)
    }
}
