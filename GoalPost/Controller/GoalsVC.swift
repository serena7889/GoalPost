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
        fetch { (complete) in
            print(goals.count)
            print(goals)
            if complete {
                if goals.count > 0 {
                    tableView.isHidden = false
                }
            }
        }
    }
    
    @IBAction func addGoalBtnPressed(_ sender: Any) {
        print("add pressed")
    }
    
    func fetch(completion: (_ complete: Bool) -> ()) {
        guard let moc = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        do {
            goals = try moc.fetch(fetchRequest)
            debugPrint("Successfully fetched data")
            completion(true)
        } catch {
            debugPrint("Cannot fetch data: \(error.localizedDescription)")
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
    
}
