//
//  DAO.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import CloudKit

//Para retornar o dao para um singleton descomentar as duas linhas abaixo
//let DAO = dao.instance

class dao{
    // static let instance = dao()
    static var database:CKDatabase?
    
    static let container = CKContainer(identifier: "iCloud.FelipeKestelman.MusicChallenge")
    
    static func configureCloud(){
        
        database = container.publicCloudDatabase
        
        container.accountStatus{(status, error) -> Void in
            
            if status == .noAccount{
                print("Sem acesso no iCloud")
                print(error!)
            }
        }
    }

    func createSong(musica: Musica){
        let song = CKRecord(recordType: "Musicas")
        song.setObject(musica.nome as CKRecordValue?, forKey: "Nome")
        song.setObject(musica.instrumentos as CKRecordValue?, forKey: "Instrumentos")
        dao.database?.save(song, completionHandler: { (result, error) in
            if error != nil {
                print("Song Added")
                return
            }
        })
    }
    
    func queryMusica(musica: Musica){
        let query = CKQuery(recordType: "Musicas", predicate: NSPredicate(value: true))
        dao.database?.perform(query, inZoneWith: nil, completionHandler: { (results, _) in
            guard let songs = results else { return }
            let sortedSongs = songs.sorted(by: { $0.creationDate! > $1.creationDate!})
            

        })
    }
    
    
}
