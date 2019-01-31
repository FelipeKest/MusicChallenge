//
//  Enums.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation
import UIKit

enum Instrument: CaseIterable{
    
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
        case .Singer: return UIImage(named: "Vocals.png")!
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

enum EventTypes {
    case Rehearsal
    case Show
    
    var image: UIImage {
        switch self {
        case .Rehearsal: return UIImage(named: "storage1.png")!
        case .Show: return UIImage(named: "stage1.png")!
        }
    }
    
    var text: String{
        switch self {
        case .Rehearsal: return "Ensaio"
        case .Show: return "Show"
        }
        
    }
}

