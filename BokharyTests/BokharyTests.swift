//
//  BokharyTests.swift
//  BokharyTests
//
//  Created by Elsayed Hussein on 6/6/19.
//  Copyright © 2019 Elsayed Hussein. All rights reserved.
//

import XCTest
@testable import Bokhary

class BokharyTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testLoadMethod() {
        
        guard let url = URL(string: "https://www.hackingwithswift.com") else {
            return
        }
        
        Bokhary.Setting.cashSize = 100
        Bokhary.load(url: url, of: .data) { (result) in
            switch result {
            case .success(let data):
                print("Data: \(String(describing: String(data: data, encoding: .utf8)))")
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
