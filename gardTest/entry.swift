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
    var data: [[ entry ]]
}

//var entryArrray = [entry]()


struct entry: Codable {
    var id : String
    var body: String
    var da: String
    var dm: String
}


/*{"status":1,"data":[[{"id":"y6nhseVYsd","body":"test text body","da":"1549224591","dm":"1549224591"}]]}*/


