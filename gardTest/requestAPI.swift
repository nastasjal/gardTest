//
//  requestAPI.swift
//  gardTest
//
//  Created by Анастасия Латыш on 12/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import Foundation

struct connectionConstants {
    let baseURL = "https://bnet.i-partner.ru/testAPI/"
    let token    = "Oqu6izM-l1-zHsoNk0"
    
}

struct requestAPI {
    
    var parametersValueForCommandAPI = [allParameters: String]()
    
    var currentCommand: apiCommand {
        return apiCommand.fromString(parametersValueForCommandAPI[allParameters.a] ?? "new_session")
    }
    
    var connectionConst = connectionConstants()
    
    var parametersLine: String {
        var line = ""
        if let parameters = parametersForCommandAPI[currentCommand] {
            for parameter in parameters {
                if let key:String = parameter.rawValue , let value: String = parametersValueForCommandAPI[parameter] {
                    line += "\(key)=\(value)&"
                }
            }
        } else {print ("API havenot this command")}
        line.removeLast()
        return line
    }
    
    
    enum apiCommand: String, CaseIterable {
        case get_entries
        case add_entry
        case new_session
        
        static func fromString(_ from: String) -> apiCommand {
            return apiCommand.allCases.first{ "\($0)" == from }!
        }
    }
    
    var decodeDataForCommand: [requestAPI.apiCommand : Any] = [apiCommand.new_session:initialSession.self, apiCommand.get_entries : initialEntry.self]
    
    
    
    enum allParameters: String, CaseIterable {
        case a
        case session
        case body
        
        static func fromString(_ from: String) -> allParameters {
            return allParameters.allCases.first{ "\($0)" == from }!
        }
    }
    
    let parametersForCommandAPI: [apiCommand:[allParameters]] = [apiCommand.get_entries:[allParameters.a,allParameters.session], apiCommand.add_entry:[allParameters.a, allParameters.body, allParameters.session], apiCommand.new_session:[allParameters.a]]
    
    
    
    
    init ( _ parameters: [String: String] ) {
        for (key , value) in parameters {
            self.parametersValueForCommandAPI[allParameters.fromString(key)] = value
        }
    }
    
    
    func generateRequest (completion: @escaping (_ error: String?, _ getData : Data?) -> Void) {
        
        guard let url = URL(string: connectionConst.baseURL) else { return }
        let parameters = parametersLine
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(connectionConst.token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if error != nil {
                completion( "check connection.", nil)
            }
            
            if let response = response  as? HTTPURLResponse {
                let result = self.handleNetworkResponse(response)
                switch result {
                case "success":
                    guard let responseData = data else {
                        completion("empty data", nil)
                        return
                    }
                    
                     completion("get data", responseData)
                    
                default :
                    completion( "response error", nil)
                }
                
            }
            
            }.resume()
    }
    
    fileprivate func handleNetworkResponse(_ response: HTTPURLResponse) -> String {
        switch response.statusCode {
        case 200...299: return "success"
        default: return "failure"
        }
    }
    
}


