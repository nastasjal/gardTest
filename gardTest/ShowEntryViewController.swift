//
//  ShowEntryViewController.swift
//  gardTest
//
//  Created by Анастасия Латыш on 04/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class ShowEntryViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        showEntry.text = textBody

    }
    
    var textBody = String()

    @IBOutlet weak var showEntry: UITextView!
    

}
