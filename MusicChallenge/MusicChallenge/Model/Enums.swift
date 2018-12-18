//
//  Enums.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import UIKit

enum InstrumentTypes {
    
    case Bass
    case Guitar
    case Drums
    case Singer
    case Others
    
    //Adicionar Imagens Correspondentes Aqui
    var image: UIImage {
        switch self {
        case .Bass: return UIImage(named: "Bass.png")!
        case .Drums: return UIImage(named: "Drums.png")!
        case .Guitar: return UIImage(named: "Guitar.png")!
        case .Singer: return UIImage(named: "voz.png")!
        case .Others: return UIImage(named: "Others.png")!
        }
    }
    
    var text: String{
        switch self {
        case .Bass: return "Bass"
        case .Guitar: return "Guitar"
        case .Singer: return "Singer"
        case .Drums: return "Drums"
        case .Others: return "Others"
        }
    }
}


