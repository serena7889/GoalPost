//
//  GoalsVC.swift
//  GoalPost
//
//  Created by Serena Lambert on 11/11/2019.
//  Copyright © 2019 Serena Lambert. All rights reserved.
//

import UIKit
import CoreData

class GoalsVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var goals = [Goal]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        fetchCoreDataObjects()
        tableView.reloadData()
    }
    
    func fetchCoreDataObjects() {
        fetch { (complete) in
            if complete {
                if goals.count > 0 {
                    tableView.isHidden = false
                } else {
                    tableView.isHidden = true
                }
            }
        }
    }
    
}


extension GoalsVC {
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let moc = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            goals = try moc.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Cannot fetch data: \(error.localizedDescription)")
        }
    }
    
    func deleteGoal(atIndexPath indexPath: IndexPath) {
        guard let moc = appDelegate?.persistentContainer.viewContext else { return }
        moc.delete(goals[indexPath.row])
        do {
            try moc.save()
        } catch {
            debugPrint("Cannot delete goal: \(error.localizedDescription)")
        }
    }
    
    func incrementGoal(atIndexPath indexPath: IndexPath) {
        guard let moc = appDelegate?.persistentContainer.viewContext else { return }
        let goal = goals[indexPath.row]
        if goal.goalCount < goal.goalTarget {
            goal.goalCount += 1
        } else {
            return
        }
        do {
            try moc.save()
        } catch {
            debugPrint("Cannot increment goal: \(error.localizedDescription)")
        }
    }

    
}




extension GoalsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell") as? GoalCell else {
            return UITableViewCell()
        }
        let goal = goals[indexPath.row]
        cell.configureCell(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "DELETE") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.deleteGoal(atIndexPath: indexPath)
            self.fetchCoreDataObjects()
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        
        let incrementAction = UIContextualAction(style: .normal, title: "+1") { (contextAction: UIContextualAction, sourceView: UIView, completionHandler: (Bool) -> Void) in
            self.incrementGoal(atIndexPath: indexPath)
            tableView.reloadData()
        }
        incrementAction.backgroundColor = #colorLiteral(red: 0.2039215686, green: 0.7803921569, blue: 0.3490196078, alpha: 1)
        
        let swipeActionsConfig = UISwipeActionsConfiguration(actions: [deleteAction, incrementAction])
        return swipeActionsConfig
    }
    
}
