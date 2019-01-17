//
//  Extenstions.swift
//  MusicChallenge
//
//  Created by Felipe Kestelman on 12/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import Foundation

extension Array where Element == Saveable {
    var idsAsString:[String] {
        var ids:[String] = []
        for item in self {
            // TODO: Estamos ignorando os caras que não foram salvos ainda
            if let id = item.id {
                ids.append(id)
            } else {
                // salva ele, e aguarda pra tentar
                
            }
        }
        return ids
    }
    
}

extension Array where Element == Instrument {
    var instrumentsAsString:[String]{
        var strings:[String] = []
        for instrument in self {
            strings.append(instrument.text)
        }
        return strings
    }
}

extension String {
    var asInstrument: Instrument {
        switch self {
            case "Bass": return .Bass
            case "Guitar": return .Guitar
            case "Singer": return .Singer
            case "Drums": return .Drums
            default: return .Others
        }
    }
}

extension Date
{
    func toString( dateFormat format  : String ) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}

extension String
{
    func toDate( dateFormat format  : String) -> Date
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: self)!
    }
    
}
