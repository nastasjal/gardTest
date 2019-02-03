//
//  AddEntryViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 03/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController {

var token = String()
var baseURL = String()
var sessionId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBOutlet weak var body: UITextField!
    

    @IBAction func closeButton(_ sender: UIButton) {
    }
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        insertEntry(text: body.text!, for: sessionId)
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
}
