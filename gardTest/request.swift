//
//  request.swift
//  gardTest
//
//  Created by Анастасия Латыш on 11/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import Foundation

struct request {
    let baseURL = "https://bnet.i-partner.ru/testAPI/"
    let token    = "Oqu6izM-l1-zHsoNk0"
    var sessionId = String()
    
    
    
    func createSession(completion: @escaping (_ id: String?) -> Void) {
        
        guard   let url = URL(string: self.baseURL) else { return }
        
        let parameters = "a=new_session"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                // self.connectionCheck()
            }
            if let httpResponse = response  as? HTTPURLResponse {
                if httpResponse.statusCode  == 200 {
                    print ("httpResponse = \(httpResponse)")
                }
                
            }
            
            
            guard let data = data else {
                print("empty data")
                return
            }
            
            do {
                let json = try JSONDecoder().decode(initialSession.self, from: data)
                completion(json.data.session)
            } catch let error as NSError {
                print("parsing error",error)
            }
            
            }.resume()
    }
    
    func selectData(completion:  @escaping (_ dataEntries: [initialEntry]?) -> Void){
        guard   let url = URL(string: self.baseURL) else { return }
        let parameters = "a=get_entries&session=\(sessionId)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let response = response {
                print("response = \(response)")
            }
            
            guard let data = data else { return }
            
            do {
                let json = try JSONDecoder().decode(initialEntry.self, from: data)
                completion([json])
            } catch {
                print("error = \(error)")
            }
            
            }.resume()
    }
    
    func insertEntry(text body: String, for sessionId: String, completion: @escaping (_ sucess: Bool) -> Void){
        guard   let url = URL(string: self.baseURL) else { return }
        
        let parameters = "a=add_entry&session=\(self.sessionId)&body=\(body)"
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(self.token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let response = response {
                print("response = \(response)")
            }
            
            guard let data = data else { return }
            
            do {
                _ = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completion(true)
            } catch {
                print("error")
            }
            
            }.resume()
    }
    
    /*   func connectionCheck(){
     let alert = UIAlertController (title: "соединение не выполнено", message: "проверьте соединение с сетью", preferredStyle: .alert)
     alert.addAction(UIAlertAction(title: "обновить данные", style: .default, handler: { (action: UIAlertAction ) -> Void in
     DispatchQueue.main.async {
     self.sessionIdCheck()
     }
     }))
     present(alert, animated: true, completion: nil)
     }
     */
    
    
}
