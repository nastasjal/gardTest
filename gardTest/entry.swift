//
//  entry.swift
//  gardTest
//
//  Created by Анастасия Латыш on 04/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import Foundation

struct initialEntry : Codable {
    var status: Int
    var data: [ entry]
}

/*
enum Data: String, Codable {
case id
case body
case da
case dm
}*/


struct entry: Codable {
    var id : String
    var body: String
    var da: Double
    var dm: Double
}


/*{"status":1,"data":[[{"id":"y6nhseVYsd","body":"test text body","da":"1549224591","dm":"1549224591"}]]}*/
