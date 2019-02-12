//
//  EntryListTableViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 03/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class EntryListTableViewController: UITableViewController {
    
    
    var requestEntry = runRequest()
 
    var entries : [initialEntry]? {
        didSet{
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let footerHeight = CGFloat(15)
    let headerHeight = CGFloat(5)
    let cellHeight = CGFloat(200)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print ("view did load")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        requestEntry.selectData(completion: {[weak self] (data) in
            self?.entries = data
        })
        
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
                addNewEntryVC.requestEntry = self.requestEntry
            }
        } else
            if segue.identifier == "ShowEntry" {
                if let indexPath = tableView.indexPathForSelectedRow, let showEntryVC = segue.destination as? ShowEntryViewController {
                    showEntryVC.textBody = entries![0].data[0][indexPath.section].body
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

