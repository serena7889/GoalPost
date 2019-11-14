//
//  GoalCell.swift
//  GoalPost
//
//  Created by Serena Lambert on 11/11/2019.
//  Copyright © 2019 Serena Lambert. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {

    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalCountLbl: UILabel!
    
    func configureCell(goal: Goal) {
        goalDescriptionLbl.text = goal.goalDescription
        goalTypeLbl.text = goal.goalType
        goalCountLbl.text = String(describing: goal.goalCount)
    }

}
