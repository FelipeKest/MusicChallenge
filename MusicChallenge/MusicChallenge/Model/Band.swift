//
//  Band.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Band:GenericProtocolClass {
    var name: String
    var members:[Musician] = []
    var repertoire: [Song] = []
    var setlists:[Setlist] = []
    var events:[Event] = []
    
    override var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["name"] = self.name
        result["members"] = self.members
        result["repertoire"] = self.repertoire
        result["setlist"] = self.setlists
        result["events"] = self.events
        return result
    }
    
    init(name:String, members:[Musician], repertoire:[Song] = [], setlists:[Setlist] = [], events: [Event] = [], id: String){
        self.name = name
        self.members = members
        self.repertoire = repertoire
        self.setlists = setlists
        self.events = events
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.members = asDictionary["members"] as! [Musician]
        super.init(id: asDictionary["id"] as? String)
        //Vejo se os musicos estao no Musico.allReferenced (ja lidos) coloco eles no members
        let membersID = asDictionary["members"] as! [String]
        // se nao
        DAO.queryAllMusicians(from: self, and: membersID) { (error) in
        
        }
        self.repertoire = asDictionary["repertoire"] as! [Song]
        self.setlists = asDictionary["setlists"] as! [Setlist]
        self.events = asDictionary["events"] as! [Event]
        
    }
    
    convenience init() {
        self.init(name: "Convience", members: [], id: "")
    }
    
}




