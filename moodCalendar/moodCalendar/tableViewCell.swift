//
//  tableViewCell.swift
//  moodCalendar
//
//  Created by LisaBebe11 on 5/5/18.
//  Copyright © 2018 LisaBebe11. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var data1Label: UILabel!
    @IBOutlet weak var data2Label: UILabel!
    
    func setup(model: Model) {
        titleLabel.text = model.title
        subtitleLabel.text = model.description
        data1Label.text = model.location
        
        if let startTime = model.StartDateTime {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            data1Label.text = dateFormatter.string(from: startTime)
            
            let timeFormatter = DateFormatter()
            timeFormatter.timeStyle = .short
            data2Label.text = timeFormatter.string(from: startTime)
        }
    }
}
