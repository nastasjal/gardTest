//
//  AddEntryViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 03/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class AddEntryViewController: UIViewController, UITextViewDelegate {
    
    
   // var requestEntry = request()
   var requestEntry =  runRequest()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bodyText.delegate = self
    }
    
    @IBOutlet weak var bodyText: UITextView!
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            bodyText.resignFirstResponder()
            return false
        }
        return true
    }
    
    
    
    @IBAction func closeButton(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    
    @IBAction func saveButton(_ sender: UIButton) {
        
        requestEntry.insertData(text: bodyText.text!) { (sucess) in
            DispatchQueue.main.async {
                if sucess {
                    self.navigationController?.popViewController(animated: true)}
            }
            
        }
  
    }
    
}
