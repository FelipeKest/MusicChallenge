//
//  Song.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

class Song:GenericProtocolClass {
    
    var name: String
    var musicians: [SongMusician] = []
    var creator: Musician? = nil
    
    static var allReferenced:[String:Song] = [:]
//    var band: Band
//    var setlists: [Setlist]

    override var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["name"] = self.name
        result["instruments"] = self.musicians
        result["creator"] = self.creator
//        result["bandID"] = self.band
//        result["setlists"] = self.setlists
        return result
    }
    
//    init(name: String, instruments: [Instrument] = [], creator: Musician, setlists: [Setlist] = [],band: Band, id: String) {
//        self.name = name
//        self.instruments = instruments
//        self.creator = creator
//        self.band = band
//        self.setlists = setlists
//        super.init(id: id)
//    }
    
    init(name: String, instruments: [SongMusician] = [SongMusician()], creator: Musician = Musician(), id: String = "") {
        self.name = name
        self.musicians = instruments
        self.creator = creator
//        self.setlists = setlists
        super.init(id: id)
    }
    
    required init(asDictionary: [String : Any]) {
        self.name = asDictionary["name"] as! String
        self.musicians = asDictionary["instruments"] as? [SongMusician] ?? []
        self.creator = asDictionary["creatorID"] as? Musician
//        self.setlists = asDictionary["setlists"] as! [Setlist]
//        self.band = asDictionary["bandID"] as! Band
        super.init(id: asDictionary["id"] as? String)
    }
    
    convenience init() {
        self.init(name: "Convenience Song", creator: Musician(), id: "Convenience Id")
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    static func asynchronousCreation(from dict:[String:Any], completionHandler: @escaping(Song?,Error?)->Void){
        DAOFacade.load(from: dict) { (song, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
                return
            } else {
                completionHandler(song,error)
            }
        }
    }
}

class SongMusician {
    var musician: Musician?
    var instrument: Instrument?
    
    init(musician: Musician, instrument: Instrument){
        self.musician = musician
        self.instrument = instrument
    }
    
    static func asynchronousCreation(from string:String,completionHandler: @escaping(SongMusician?,Error?)->Void){
        let instrumentTxt = string.split(separator: "|")[1]
        let instrument = String(instrumentTxt).asInstrument
        let musicianTxt = string.split(separator: "|")[0]
        DAO.fetchMusician(id: String(musicianTxt)) { (musician, error) in
            if error != nil {
                print(error?.localizedDescription as Any)
                completionHandler(nil,error)
            } else {
                guard let musician = musician else {return}
                let songMusician = SongMusician(musician: musician, instrument: instrument)
                completionHandler(songMusician,error)
            }
        }
    }
    
    
    convenience init(){
        self.init(musician:Musician(),instrument:Instrument.Bass)
    }
}
