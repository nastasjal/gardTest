//
//  request.swift
//  gardTest
//
//  Created by Анастасия Латыш on 11/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import Foundation

struct runRequest {
    
    private static let defaults = UserDefaults.standard
    private static let key = "session"
    
    var sessionId : String {
        get {
           if let id = (runRequest.defaults.object(forKey: runRequest.key) as? String) {
                return id
                
            }
            return ""
        }
    }
    
    func getSessionId(completion:  @escaping (_ id: String) -> Void) {
        let parameters = [ "a":"new_session"]
        let testRequest = requestAPI(parameters)
        testRequest.generateRequest { (error , data) in
            do {
                let sessionId = try JSONDecoder().decode(initialSession.self, from: data!)
                completion(sessionId.data.session)
            } catch let error as NSError {
                print("parsing error",error)
            }
            
        }
    }
    
func selectData( completion:  @escaping (_ dataEntries: [initialEntry]?) -> Void) {
        let parameters = [ "a":"get_entries", "session":sessionId]
        let testRequest = requestAPI(parameters)
    
    if sessionId != "" {
        testRequest.generateRequest { (error , data) in
            do {
                let entry = try JSONDecoder().decode(initialEntry.self, from: data!)
                completion([entry])
            } catch let error as NSError {
                print("parsing error",error)
            }
            
        }
    }
    }
    
    
    
    func insertData(text: String, completion:  @escaping (_ sucess: Bool) -> Void){
        let parameters = [ "body":text, "a":"add_entry", "session":sessionId]
        let testRequest = requestAPI(parameters)
        
        testRequest.generateRequest { (error , data) in
            completion(true)
        }
        
    }
    

    init() {
        if (runRequest.defaults.object(forKey: runRequest.key) as? String) == nil {
            self.getSessionId { (id) in
                DispatchQueue.main.async {
                    print ("main get session")
                    runRequest.defaults.set(id, forKey: runRequest.key)
                }
            }
        }
    }
    
    
}



