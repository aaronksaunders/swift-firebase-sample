//
//  MessageTableViewCell.swift
//  fbOne
//
//  Created by Aaron Saunders on 4/4/16.
//  Copyright © 2016 Aaron Saunders. All rights reserved.
//

import UIKit

class MessageTableViewCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    func configureCell(data:[String:String]) {
        self.textLabel?.text = data["text"]!
        self.detailTextLabel!.text = data["date"]!
    }
}