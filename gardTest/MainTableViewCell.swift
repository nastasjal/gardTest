//
//  MainTableViewCell.swift
//  gardTest
//
//  Created by Анастасия Латыш on 04/02/2019.
//  Copyright © 2019 Анастасия Латыш. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var bodyLabel: UILabel!
    


}

extension String {
    func truncated() -> Substring {
        return prefix(200)
    }
}
