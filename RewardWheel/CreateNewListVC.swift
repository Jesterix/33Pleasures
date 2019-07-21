//
//  CreateNewListVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 27/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import CoreData

//VC for creating and editing reward lists. Responsible for interaction with database about Rewards, adding them into lists.
class CreateNewListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let minimumRewardsInList = 4//this number restricts from creating too small lists because they don't look great in spinning wheel
    var rewardList : RewardList?
    var rewardListArray : [Reward] = []//this is an array for Rewards in current RewardsList
    var newListName = String()
    var rewards : [Reward] = []//this is an array for all Rewards in database
    var numberOfElementToEdit = -1
    var fetchResultController = NSFetchedResultsController<Reward>()
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var listNameField: UITextField!
    
    @IBOutlet weak var addingRewardField: AccessoryTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setting up VC
        if let listToEdit = rewardList {
            if listToEdit.rewards.count > 0 {
                listNameField.text = listToEdit.name ?? ""
                rewardListArray = Array(listToEdit.rewards)
            }
            self.title = "Edit reward list"
        } else {
            self.title = "Create new reward list"
        }
        
        
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
                rewards = fetchedObjects
            }
        } catch {
            print(error)
        }
    }
    
    //this func is for translating Int16 to certain background colors
    func setColorFromInt16(value: Int16) -> UIColor {
        switch value {
        case 0:
            return UIColor.cyan
        case 1:
            return UIColor.blue
        case 2:
            return UIColor.orange
        case 3:
            return UIColor.green
        default:
            return UIColor.red
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rewardListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = rewardListArray[indexPath.row].name
        cell.textLabel?.textColor = setColorFromInt16(value: rewardListArray[indexPath.row].category)
        cell.selectionStyle = .none
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            rewardListArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        addingRewardField.becomeFirstResponder()
        addingRewardField.text = rewardListArray[indexPath.row].name
        numberOfElementToEdit = indexPath.row
        addingRewardField.accessoryVC?.view().categoryControl.selectedSegmentIndex = Int(rewardListArray[indexPath.row].category)
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        //creates new or saves existing reward list and pops view controller to previous screen
        print("save to coredata")
        if rewardList != nil {
            if rewardListArray.count >= minimumRewardsInList  {
                rewardList?.rewards.removeAll()
                for rwrd in rewardListArray {
                    rewardList?.rewards.insert(rwrd)
                }
                CoreDataManager.instance.saveContext()
                self.navigationController?.popViewController(animated: true)
            } else {
                presentAlertOfRequirements()
            }
        } else {
            if rewardListArray.count >= minimumRewardsInList {
                let newRewardList = RewardList()
                newListName = listNameField.text ?? ""
                newRewardList.name = newListName
                for reward in rewardListArray {
                    newRewardList.rewards.insert(reward)
                }
                CoreDataManager.instance.saveContext()
                self.navigationController?.popViewController(animated: true)
            } else {
                presentAlertOfRequirements()
            }
        }
        print("test?")
    }
    
    
    func presentAlertOfRequirements() {
        let alert = UIAlertController(title: "Add \(minimumRewardsInList) rewards minimum", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func appendReward(reward: Reward) {
        //this func appends new reward in list or edit existing one
        if numberOfElementToEdit >= 0 {
            rewardListArray[numberOfElementToEdit] = reward
            numberOfElementToEdit = -1
        } else {
            rewardListArray.append(reward)
        }
    }
    
    
    @IBAction func newRewardFieldCompleted(_ sender: UITextField) {
        //Checks whether entered reward is in database or not. Adds it to current RewardList.
        print("segment control is: \(String(describing: addingRewardField.accessoryVC?.view().categoryControl.selectedSegmentIndex))")
        if let rewardText = sender.text {
            if rewardText != "" {
                var inBase = false
                for rwrd in rewards {
                    if rewardText == rwrd.name {
                        print("есть такая реварда в базе")
                        inBase = true
                        var inList = false
                        for rewrd in rewardListArray {
                            if rewardText == rewrd.name {
                                inList = true
                                print("есть такая реварда в листе")
                            }
                        }
                        if !inList {
                            appendReward(reward: rwrd)
                        }
                        break
                    }
                }
                if !inBase {
                    if let accessoryVC = addingRewardField.accessoryVC {
                        let category = Int16(accessoryVC.view().categoryControl.selectedSegmentIndex)
                        let newReward = Reward()
                        newReward.name = rewardText
                        newReward.category = category
                        CoreDataManager.instance.saveContext()
                        rewards.append(newReward)
                        print("добавлена реварда \(newReward.name!) c категорией \(newReward.category)")
                        appendReward(reward: newReward)
                    }
                }
            }
        }
        listTableView.reloadData()
        sender.text = ""
    }
    
    //for search and autocomplete rewards
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        let searchResult = rewards.filter { (result) -> Bool in
            if let name = result.name {
                return name.contains(sender.text!)
            } else {
                return false
            }
        }
        addingRewardField.accessoryVC?.tableDataSource = searchResult
        addingRewardField.accessoryVC?.reloadData()
    }
}

extension CreateNewListVC: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let listToEdit = rewardList {
            listToEdit.name = textField.text
        } else {
            newListName = textField.text ?? ""
        }
    }
    

}

