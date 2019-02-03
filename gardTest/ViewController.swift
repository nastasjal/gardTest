//
//  ViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 02/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    //{"status":1,"data":{"token":"Oqu6izM-l1-zHsoNk0"}}
    
    
    let baseURL = "https://bnet.i-partner.ru/testAPI/"
    let token    = "Oqu6izM-l1-zHsoNk0"
    var sessionId = String()
    
    override func viewDidLoad() {
        
        createSession { (id) in
            self.sessionId = id!
        }
        
        print ("session idW = \(sessionId)")
  
    }
    
    //curl --header "token: Oqu6izM-l1-zHsoNk0" --data "a=new_session" https://bnet.i-partner.ru/testAPI/
    //curl --header "token: Oqu6izM-l1-zHsoNk0" --data "a=add_entry&session=nu8fRSXUhIJMKmzDdM&body="tratata"" https://bnet.i-partner.ru/testAPI/
   
    //curl --header "token: Oqu6izM-l1-zHsoNk0" --data "a=get_entries&session=OcbMkVzE4uYCrJAgm5" https://bnet.i-partner.ru/testAPI/
    
   func createSession(completion: @escaping (_ id: String?) -> Void) {
        
    guard   let url = URL(string: self.baseURL) else { return }
    
    let parameters = "a=new_session"
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("\(token)", forHTTPHeaderField: "token")
    request.httpBody = parameters.data(using: .utf8)
    
    URLSession.shared.dataTask(with: request) { data, response, error in
       
        guard let data = data else {
            print("empty data")
            return
        }
        
        do {
            let json = try JSONDecoder().decode(initialSession.self, from: data)
         //   print ("session id = \(json.data.session)")
            completion(json.data.session)
        } catch let error as NSError {
            print("error",error)
        }
        
        }.resume()
    }
    
    
    func insertEntry(text body: String, for sessionId: String){
        guard   let url = URL(string: self.baseURL) else { return }
        
        let parameters = "a=add_entry&session=\(sessionId)&body=\(body)"
        print ("parameters = \(parameters)")
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
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                print("json = \(json)")
            } catch {
                print("error")
            }
            
            }.resume()
    }
    
    
    @IBAction func insertData(_ sender: UIButton) {
        
        insertEntry(text: "test text body", for: sessionId)
    /*   guard   let url = URL(string: self.baseURL) else { return }
        
        let parameters = "a=new_session"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
     
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                print("empty data")
                return
            }
     
            
     /*    let dataString = String(data: data, encoding: .utf8)
           print(dataString)
       */
            do {
                let json = try JSONDecoder().decode(initialSession.self, from: data)
                print ("session id = \(json.data.session)")
            } catch let error as NSError {
                print("eee",error)
            }
            
            }.resume()*/
    }
    
    
    @IBAction func selectData(_ sender: UIButton) {
        guard   let baseURL = URL(string: self.baseURL) else { return }
        
        var request = URLRequest(url: baseURL)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            
            if let response = response {
                print(response)
            }
            
             guard let data = data else { return }
            
            do {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            } catch {
                print("error")
            }
            
        }.resume()
    }
   

}

