//
//  MusicChallengeTest.swift
//  MusicChallengeTests
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import XCTest
import CloudKit



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
        let song = Song(name: "BYOB", instruments: [instrument.Bass.text, instrument.Guitar.text, instrument.Singer.text, instrument.Drums.text])
        var newRecord: CKRecord?
        print("OUT OF COMPLETION")
        DAO.createSong(Song: song) { (result, error) in
            print(result)
        }
        print(newRecord?.object(forKey: "name") as Any)
        // let songReturn = DAO.querySong(Song: song)
    //    XCTAssert((newRecord!.value(forKey: "name") as! String) == (songReturn.value(forKey: "name") as! String))
    }

}
