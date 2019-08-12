//
//  StatsVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 10/08/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import CoreData

//this VC controls stats screen and is responsible for discarding stats
class StatsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var rewards : [Reward] = []//this is an array for all Rewards in database
    var fetchResultController = NSFetchedResultsController<Reward>()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UINib(nibName: "StatsCell", bundle: nil), forCellReuseIdentifier: "StatsCell")
        
        // Fetch data from data storage
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = CoreDataManager.instance.persistentContainer.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let fetchedObjects = fetchResultController.fetchedObjects {
                rewards = fetchedObjects.sorted(by: { $0.wasSelected > $1.wasSelected })
            }
        } catch {
            print(error)
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 2:
            return 1
        default:
            return rewards.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StatsCell", for: indexPath) as! StatsCell
        let cellCountChecker = rewards.count - indexPath.row - indexPath.section
        if cellCountChecker > 0 {
            cell.nameLabel.text = rewards[indexPath.row + indexPath.section].name
            cell.wasSelectedLabel.text = String(rewards[indexPath.row + indexPath.section].wasSelected)
        } else {
            cell.nameLabel.text = rewards[rewards.count - indexPath.section - cellCountChecker].name
            cell.wasSelectedLabel.text = String(rewards[rewards.count - indexPath.section - cellCountChecker].wasSelected)
        }

        switch indexPath.section {
        case 0:
            cell.backgroundColor = UIColor.yellow
        case 1:
            cell.backgroundColor = UIColor.lightGray
        case 2:
            cell.backgroundColor = UIColor.orange
        default:
            cell.backgroundColor = UIColor.white
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return NSLocalizedString("The most popular reward is:", comment: "first reward")
        case 1:
            return NSLocalizedString("The second popular reward is:", comment: "second reward")
        case 2:
            return NSLocalizedString("The third popular reward is:", comment: "third reward")
        default:
            return NSLocalizedString("Other rewards:", comment: "other rewards")
        }
    }
    

    @IBAction func discardTapped(_ sender: Any) {
        let alert = UIAlertController(title: NSLocalizedString("Discard all stats", comment: "discarding header"), message: NSLocalizedString("This will discard all statistics. Are you shure?", comment: "discarding message"), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Discard", comment: "discarding button"), style: .destructive, handler: { (action) in
            self.discardStatistics()
        }))
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "cancelling button"), style: .cancel, handler: nil))
        self.present(alert, animated: true)
    }
    
    func discardStatistics(){
        for reward in rewards {
            reward.wasSelected = 0
        }
        CoreDataManager.instance.saveContext()
    }
}
