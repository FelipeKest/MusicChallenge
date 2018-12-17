//
//  ViewController.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 08/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let musica = Musica(nome: "BYOB", instrumentos: [Instrumento.Baixo.text])
        let playlist = Playlist(name: "Metal", musicas: [musica])
        
//        DAO.createSong(musica: musica) { (record, error) in
//            if error != nil {
//               print(record as Any)
//            } else {
//                print(error?.localizedDescription as Any)
//            }
//        }
        DAO.createPlaylist(playlist: playlist) { (result, error) in
            if error != nil {
                print(playlist as Any)
            } else {
                print(error?.localizedDescription as Any)
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    
}

