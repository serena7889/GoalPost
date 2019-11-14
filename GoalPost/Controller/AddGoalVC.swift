//
//  AddGoalVC.swift
//  GoalPost
//
//  Created by Serena Lambert on 14/11/2019.
//  Copyright © 2019 Serena Lambert. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class AddGoalVC: UIViewController, UITextViewDelegate {
    
    let selectedGreen = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
    let unselectedGreen = #colorLiteral(red: 0.543347204, green: 0.7803921569, blue: 0.6030115799, alpha: 1)
    
    @IBOutlet weak var shortTermBtn: UIButton!
    @IBOutlet weak var longTermBtn: UIButton!
    @IBOutlet weak var goalDescTextView: UITextView!
    @IBOutlet weak var goalCountLbl: UILabel!
    @IBOutlet weak var minusBtn: UIButton!
    @IBOutlet weak var plusBtn: UIButton!
    
    var goalType = GoalType.shortTerm
    var goalTarget = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalDescTextView.delegate = self
        updateGoalType()
        updateGoalTarget(change: 0)
    }
    
    func updateGoalType() {
        if goalType == .shortTerm {
            shortTermBtn.backgroundColor = selectedGreen
            longTermBtn.backgroundColor = unselectedGreen
        } else {
            longTermBtn.backgroundColor = selectedGreen
            shortTermBtn.backgroundColor = unselectedGreen
        }
    }
    
    func updateGoalTarget(change: Int) {
       goalTarget += change
        goalCountLbl.text = String(describing: goalTarget)
        if goalTarget == 1 {
            minusBtn.isEnabled = false
        } else if goalTarget == 5 {
            plusBtn.isEnabled = false
        } else {
            minusBtn.isEnabled = true
            plusBtn.isEnabled = true
        }
    }
    
    func valid() -> Bool {
        return (goalDescTextView.text != "")
    }
    
    func save(completion: (_ finished: Bool) -> ()) {
        guard let moc = appDelegate?.persistentContainer.viewContext else { return }
        let goal = Goal(context: moc)
        goal.goalTarget = Int32(goalTarget)
        goal.goalCount = 0
        goal.goalType = goalType.rawValue
        goal.goalDescription = goalDescTextView.text
        do {
            try moc.save()
            completion(true)
        } catch {
            debugPrint("Could not save: \(error.localizedDescription)")
            completion(false)
        }
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        if valid() {
            save { (complete) in
                if (complete) {
                    dismiss(animated: true, completion: nil)
                }
            }
        }
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func shortTermBtnPressed(_ sender: Any) {
        goalType = .shortTerm
        updateGoalType()
    }
    
    @IBAction func longTermBtnPressed(_ sender: Any) {
        goalType = .longTerm
        updateGoalType()
    }
    
    @IBAction func minusBtnPressed(_ sender: Any) {
        updateGoalTarget(change: -1)
    }
    
    @IBAction func plusBtnPressed(_ sender: Any) {
        updateGoalTarget(change: 1)
    }
    
    

}
