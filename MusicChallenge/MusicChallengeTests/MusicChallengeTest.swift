//
//  MusicChallengeTest.swift
//  MusicChallengeTests
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import XCTest
import CloudKit
@testable import MusicChallenge


class MusicChallengeTest: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Aprendendo Unit Test
    //Se quiserem aprender criem outras Classes XCTestCase
    func testJson(){
        let song = Musica(nome: "BYOB", instrumentos: [Instrumento.Baixo.text, Instrumento.Guitarra.text, Instrumento.Vocalista.text, Instrumento.Bateria.text])
        var newRecord: CKRecord?
        print("OUT OF COMPLETION")
        DAO.createSong(musica: song) { (result, error) in
            print(result)
        }
        print(newRecord?.object(forKey: "Nome") as Any)
        // let songReturn = DAO.queryMusica(musica: song)
    //    XCTAssert((newRecord!.value(forKey: "Nome") as! String) == (songReturn.value(forKey: "Nome") as! String))
    }

}
