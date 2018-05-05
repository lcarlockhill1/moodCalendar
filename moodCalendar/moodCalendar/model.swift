//
//  model.swift
//  moodCalendar
//
//  Created by LisaBebe11 on 5/5/18.
//  Copyright © 2018 LisaBebe11. All rights reserved.
//

/*
 This is the model class that holds your data.
 This model is what is shown in a tableview, collectionview, pickerview row, etc.
 */

import UIKit

struct Model {
    var eventIdentifier = ""
    var title = ""
    var description: String?
    var location: String?
    var StartDateTime: Date?
}
