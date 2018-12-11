//
//  MusicChallengeTest.swift
//  MusicChallengeTests
//
//  Created by Felipe Kestelman on 11/12/18.
//  Copyright © 2018 Felipe Kestelman. All rights reserved.
//

import XCTest
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
    func testNumber1(){
        let val = dao()
        let one = 1
        XCTAssertTrue(val.createPost()==one)
    }

}
