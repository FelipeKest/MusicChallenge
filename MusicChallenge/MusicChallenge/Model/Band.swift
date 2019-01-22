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
    static var allReferenced:[String:Band] = [:]
    
    override var asDictionary:[String:Any] {
        var result:[String:Any] = [:]
        result["id"] = self.id
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
        Band.allReferenced[id] = self
    }
    
    required init(asDictionary: [String : Any]) {
        //Colocar o membro no id aqui
        self.name = asDictionary["name"] as! String
        super.init(id: asDictionary["id"] as? String)
        //Vejo se os musicos estao no Musico.allReferenced (ja lidos) coloco eles no members
        guard let id = asDictionary["id"] as? String else {return}
        DAOFacade.load(band: self, from: asDictionary) { (error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                return
            }
            Band.allReferenced[id] = self
        }
    }

//    func bandAsynchtonousInit(from dict:[String:Any], with completionHandler: @escaping(Band?,Error?)->Void){
//        let name = dict["name"]
//        let id = dict["id"]
//        var band: Band
//        DAOFacade.load(band: self, from: dict) { (error) in
//
//        }
//    }
    
    convenience init() {
        self.init(name: "Convieniece", members: [], id: "")
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
}




