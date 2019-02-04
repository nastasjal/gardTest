//
//  EntryListTableViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 03/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {

    private static let defaults = UserDefaults.standard
    private static let key = "session"
    
  /*  static var searches: Int {
        return (defaults.object(forKey: key) as? Int) ?? self.goalDefault
    }*/
    
    let baseURL = "https://bnet.i-partner.ru/testAPI/"
    let token    = "Oqu6izM-l1-zHsoNk0"
    var sessionId = String()
    var entries : [initialEntry]?
    let footerHeight = CGFloat(15)
    let headerHeight = CGFloat(5)
    let cellHeight = CGFloat(200)
    
    override func viewDidLoad() {
        super.viewDidLoad()

     /*   if let Id = (EntryListTableViewController.defaults.object(forKey: EntryListTableViewController.key) as? String) {
            sessionId = Id
            
        } else {
            createSession { (id) in
                self.sessionId = id!
                EntryListTableViewController.defaults.set(id!, forKey: EntryListTableViewController.key)
            }
        }*/
        sessionIdCheck()
        
  // selectData()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
         selectData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return entries?[0].data[0].count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entries![0].data[0][section].da != entries![0].data[0][section].dm ? 2 : 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
            if let mainCell = cell as? MainTableViewCell {
                mainCell.bodyLabel.text = String(entries![0].data[0][indexPath.section].body.truncated())
                mainCell.createdLabel.text = convertDate(for: entries![0].data[0][indexPath.section].da)
            }
             return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterTableViewCell", for: indexPath)
            if let footerCell = cell as? FooterTableViewCell {
                footerCell.changedLabel.text = "changed: \(convertDate(for: entries![0].data[0][indexPath.section].dm))"
            }
              return cell
        }
      
    }
 
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return entries![0].data[0][indexPath.section].da != entries![0].data[0][indexPath.section].dm ? ( indexPath.row == 0 ? cellHeight : footerHeight ) : cellHeight
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return headerHeight
    }
 

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewEntry" {
            if let addNewEntryVC = segue.destination as? AddEntryViewController {
                    addNewEntryVC.baseURL = baseURL
               addNewEntryVC.sessionId = sessionId
                addNewEntryVC.token = token
            }
        } else
            if segue.identifier == "ShowEntry" {
                if let indexPath = tableView.indexPathForSelectedRow, let showEntryVC = segue.destination as? ShowEntryViewController {
                    showEntryVC.textBody = entries![0].data[0][indexPath.section].body
                }
        }
        
    }
    
    //MARK: work with API
    
    func createSession(completion: @escaping (_ id: String?) -> Void) {
        
        guard   let url = URL(string: self.baseURL) else { return }
        
        let parameters = "a=new_session"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "token")
        request.httpBody = parameters.data(using: .utf8)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if error != nil {
                print(error)
                self.connectionCheck()
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
                print("error point 2",error)
            }
            
            }.resume()
    }
    
    func connectionCheck(){
         let alert = UIAlertController (title: "соединение не выполнено", message: "проверьте соединение с сетью", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "обновить данные", style: .default, handler: { (action: UIAlertAction ) -> Void in
            DispatchQueue.main.async {
                self.sessionIdCheck()
            }
            }))
        present(alert, animated: true, completion: nil)
    }
    
    func selectData(){
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
                let entryData = try JSONDecoder().decode(initialEntry.self, from: data)
                
                DispatchQueue.main.async {
                    self.entries = [entryData]
                    self.tableView.reloadData()
                     print("json = \(entryData)")
                }
                
                print("json = \(entryData)")
            } catch {
                print("error = \(error)")
            }
            
            }.resume()
    }
    
    
    func sessionIdCheck(){
        if let Id = (EntryListTableViewController.defaults.object(forKey: EntryListTableViewController.key) as? String) {
            self.sessionId = Id
            
        } else {
            createSession { (id) in
                self.sessionId = id!
                EntryListTableViewController.defaults.set(id!, forKey: EntryListTableViewController.key)
            }
        }
    }
    
    func convertDate(for unixtimeInterval: String) -> String {
        let date = Date(timeIntervalSince1970: Double(unixtimeInterval)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as TimeZone?
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy"
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

}

