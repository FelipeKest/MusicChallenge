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
let DAO = dao.instance

class dao{
    static let instance = dao()
    var database:CKDatabase?
    let container = CKContainer(identifier: "iCloud.FelipeKestelman.MusicChallenge")
    
    private init(){
        self.configureCloud()
    }
    
    func configureCloud(){
        
        database = container.publicCloudDatabase
        
        container.accountStatus{(status, error) -> Void in
            
            if status == .noAccount{
                print("Sem acesso no iCloud")
                print(error!)
            }
        }
    }

    
    func createSong(musica: Musica, completionHandler: @escaping (CKRecord?,Error?)->Void){
        let songRecord = CKRecord(recordType: "Musica")
        songRecord.setObject(musica.nome as CKRecordValue?, forKey: "Nome")
        songRecord.setObject(musica.instrumentos as CKRecordValue?, forKey: "Instrumentos")
        database?.save(songRecord, completionHandler: { (result, error) in
            if error != nil {
                completionHandler(nil,error)
            } else {
                completionHandler(result, nil)
            }
        })
    }
    
    
    
    func queryMusica(musica: Musica)->CKRecord{
        var musicaRecord: CKRecord?
        
        database?.fetch(withRecordID: musica.musicaId!, completionHandler: { (result, error) in
            if error == nil {
                musicaRecord = result
            } else {
                print(error?.localizedDescription as Any)
                return
            }
        })
        return musicaRecord!
    }
    
}
