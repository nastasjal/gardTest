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


struct entry: Codable {
    var id : String
    var body: String
    var da: String
    var dm: String
}



