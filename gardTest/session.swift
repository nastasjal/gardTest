//
//  session.swift
//  gardTest
//
//  Created by Анастасия Латыш on 03/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import Foundation

struct initialSession : Codable {
    var status: Int
    var data: session
}

struct session: Codable {
    var session : String
}
