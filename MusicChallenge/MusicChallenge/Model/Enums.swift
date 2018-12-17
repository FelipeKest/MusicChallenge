//
//  Enums.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import UIKit

enum InstrumentTypes: Saveable {
    
    var id: String?
    
    var asDictionary: [String : Any] {
        var result: [String:Any] = [:]
        result["id"] = self.id
        result["tipo"] = self.text
    }
    
    case Baixo
    case Guitarra
    case Bateria
    case Vocalista
    case Outros
    
    //Adicionar Imagens Correspondentes Aqui
    var image: UIImage {
        switch self {
        case .Baixo: return UIImage(named: "baixo.png")!
        case .Bateria: return UIImage(named: "bateria.png")!
        case .Guitarra: return UIImage(named: "guitarra.png")!
        case .Vocalista: return UIImage(named: "voz.png")!
        case .Outros: return UIImage(named: "outros.png")!
        }
    }
    
    var text: String{
        switch self {
        case .Baixo: return "Baixo"
        case .Guitarra: return "Guitarra"
        case .Vocalista: return "Vocalista"
        case .Bateria: return "Bateria"
        case .Outros: return "Outros"
        }
    }
}


