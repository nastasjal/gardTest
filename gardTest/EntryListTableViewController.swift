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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let Id = (EntryListTableViewController.defaults.object(forKey: EntryListTableViewController.key) as? String) {
            sessionId = Id
            
        } else {
            createSession { (id) in
                self.sessionId = id!
                EntryListTableViewController.defaults.set(id!, forKey: EntryListTableViewController.key)
            }
        }
     
        
   selectData()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0//entries?.count ?? 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0//entries![section].data.da != entries![section].data.dm ? 2 : 1
        //steps![section].sumOfSteps > goal ? 2 : 1
    }

    
 /*   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "MainTableViewCell", for: indexPath)
            if let mainCell = cell as? MainTableViewCell {
                mainCell.bodyLabel.text = entries![indexPath.section].data.body
                mainCell.createdLabel.text = convertDate(for: entries![indexPath.section].data.da)
            }
             return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "FooterTableViewCell", for: indexPath)
            if let footerCell = cell as? FooterTableViewCell {
               footerCell.changedLabel.text = convertDate(for: entries![indexPath.section].data.dm)
            }
              return cell
        }
      
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddNewEntry" {
            print ("\(segue.destination)")
            if let addNewEntryVC = segue.destination as? AddEntryViewController {
                    addNewEntryVC.baseURL = baseURL
               addNewEntryVC.sessionId = sessionId
                addNewEntryVC.token = token
            }
        }
    }
    
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
                completion(json.data.session)
            } catch let error as NSError {
                print("error",error)
            }
            
            }.resume()
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
                let entryData = try JSONDecoder().decode([initialEntry].self, from: data)
                
                DispatchQueue.main.async {
                    self.entries = entryData
                    self.tableView.reloadData()
                     print("json = \(entryData)")
                }
                
                print("json = \(entryData)")
            } catch {
                print("error = \(error)")
            }
            
            }.resume()
    }
    
    func convertDate(for unixtimeInterval: Double) -> String {
        var tempDate = String(unixtimeInterval)
        let date = Date(timeIntervalSince1970: Double(tempDate)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "GMT") as! TimeZone//Set timezone that you want
        dateFormatter.locale = NSLocale.current
        dateFormatter.dateFormat = "dd.MM.yyyy" //Specify your format that you want
        let strDate = dateFormatter.string(from: date)
        return strDate
    }

}

