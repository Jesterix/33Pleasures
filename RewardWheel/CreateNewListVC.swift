//
//  CreateNewListVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 27/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import CoreData

class CreateNewListVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
    
    let minimumRewardsInList = 4
    var rewardList : RewardList?
    var rewardListArray : [Reward] = []
    var newListName = String()
    var rewards : [Reward] = []
    var numberOfElementToEdit = -1
    var fetchResultController = NSFetchedResultsController<Reward>()
    var customInputVC = CustomInputVC()
    
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var listNameField: UITextField!
    
    @IBOutlet weak var addingRewardField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let listToEdit = rewardList {
            if listToEdit.rewards.count > 0 {
                listNameField.text = listToEdit.name ?? ""
                rewardListArray = Array(listToEdit.rewards)
            }
            self.title = "Edit reward list"
        } else {
            self.title = "Create new reward list"
        }
        
        //setting up inputAccessoryView
        let accessoryFrame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 130)
        customInputVC.frame = accessoryFrame
        addingRewardField.inputAccessoryView = customInputVC.view()
        

        
        
        
        // Fetch data from data store
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return rewardListArray.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = rewardListArray[indexPath.row].name
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
    }
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        //here will be saving in database code
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
        let alert = UIAlertController(title: "Add 4 rewards minimum", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    
    func appendReward(reward: Reward) {
        if numberOfElementToEdit >= 0 {
            rewardListArray[numberOfElementToEdit] = reward
            numberOfElementToEdit = -1
        } else {
            rewardListArray.append(reward)
        }
    }
    
    
    @IBAction func newRewardFieldCompleted(_ sender: UITextField) {
        print("segment control is: \(customInputVC.view().categoryControl.selectedSegmentIndex)")
        if let rewardText = sender.text {
            if rewardText != "" {
                var inBase = false
                for rwrd in rewards {
                    if rewardText == rwrd.name {
                        print("есть такая реварда в базе")
                        inBase = true
                        appendReward(reward: rwrd)
                        break
                    }
                }
                if !inBase {
                    let newReward = Reward()
                    newReward.name = rewardText
                    newReward.category = 0
                    CoreDataManager.instance.saveContext()
                    rewards.append(newReward)
                    print("добавлена реварда \(newReward.name!) c категорией \(newReward.category)")
                    appendReward(reward: newReward)
                }
            }
        }
        listTableView.reloadData()
        sender.text = ""
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

