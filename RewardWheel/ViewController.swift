//
//  ViewController.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 22/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import CoreData

//Initial VC which is responsible for getting RewardLists from data storage, displaying them in table view. Also contains transaction logic from this screen.
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    var rowToSend = 0
    var rewardLists : [RewardList] = []
    var fetchResultController = NSFetchedResultsController<RewardList>()
 
    @IBOutlet weak var rewardListTableView: UITableView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Fetch data from data store
        let fetchRequest: NSFetchRequest<RewardList> = RewardList.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        let context = CoreDataManager.instance.persistentContainer.viewContext
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchResultController.delegate = self
        
        do {
            try fetchResultController.performFetch()
            if let fetchedObjects = fetchResultController.fetchedObjects {
                rewardLists = fetchedObjects
            }
        } catch {
            print(error)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewardLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "rewardListCell", for: indexPath) as! RewardListTableViewCell
        cell.rewardListNameLabel.text = rewardLists[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowToSend = indexPath.row + 1
        performSegue(withIdentifier: "toWheelSegue", sender: self)
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "delete") { (rowAction, indexPath) in
            self.rowToSend = indexPath.row - 1
            //delete row
            print("delete row")
            
            let context = CoreDataManager.instance.persistentContainer.viewContext
            let rewardToDelete = self.fetchResultController.object(at: indexPath)
            context.delete(rewardToDelete)
            CoreDataManager.instance.saveContext()
        }
        deleteAction.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        
        
        let editAction = UITableViewRowAction(style: UITableViewRowAction.Style.normal, title: "edit") { (rowAction, indexPath) in
            self.rowToSend = indexPath.row + 1
            self.performSegue(withIdentifier: "addListSegue", sender: self)
        }
        editAction.backgroundColor = UIColor(red: 0, green: 0.5, blue: 1, alpha: 1)
        
        return [deleteAction, editAction]
    }

    
    @IBAction func addListTapped(_ sender: UIBarButtonItem) {
        rowToSend = 0
        performSegue(withIdentifier: "addListSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWheelSegue" {
            
            if let destination = segue.destination as? WheelViewController {
                
                
                destination.wheelSlicesAmount = rewardLists[rowToSend - 1].rewards.count
                destination.rewardList = Array(rewardLists[rowToSend - 1].rewards)//rewardLists[rowToSend - 1].rewards ?? []
            }
        }
        if segue.identifier == "addListSegue" {
            if rowToSend != 0 {
                if let destination = segue.destination as? CreateNewListVC {
                    destination.rewardList = rewardLists[rowToSend - 1]
                }
            }
        }
    }
    
    
    // MARK: NSFetchedResultsControllerDelegate
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rewardListTableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                rewardListTableView.insertRows(at: [newIndexPath], with: .fade)
            }
        case .delete:
            if let indexPath = indexPath {
                rewardListTableView.deleteRows(at: [indexPath], with: .fade)
            }
        case .update:
            if let indexPath = indexPath {
                rewardListTableView.reloadRows(at: [indexPath], with: .fade)
            }
        default:
            rewardListTableView.reloadData()
        }
        
        if let fetchedObjects = controller.fetchedObjects {
            rewardLists = fetchedObjects as! [RewardList]
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        rewardListTableView.endUpdates()
    }

}

