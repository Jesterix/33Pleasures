//
//  CreateNewListVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 27/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class CreateNewListVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let minimumRewardsInList = 4
    var rewardList : RewardList?
    var newListName = String()
    var newRewardArray = [String]()
    
    @IBOutlet weak var listTableView: UITableView!
    
    @IBOutlet weak var listNameField: UITextField!
    
    @IBOutlet weak var addingRewardField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if let listToEdit = rewardList {
            if listToEdit.rewards.count > 0 {
                listNameField.text = listToEdit.name ?? ""
            }
            self.title = "Edit reward list"
        } else {
            self.title = "Create new reward list"
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let listToEdit = rewardList {
            return listToEdit.rewards.count
        } else {
            return newRewardArray.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        if let listToEdit = rewardList {
            cell.textLabel?.text = listToEdit.rewards[indexPath.row]
        } else {
            cell.textLabel?.text = newRewardArray[indexPath.row]
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            if let listToEdit = rewardList {
                listToEdit.rewards.remove(at: indexPath.row)
            } else {
                newRewardArray.remove(at: indexPath.row)
            }
        }
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
    
    @IBAction func saveTapped(_ sender: UIBarButtonItem) {
        //here will be saving in database code
        print("save to coredata")
        if let listToEdit = rewardList {
            if listToEdit.rewards.count >= minimumRewardsInList  {
                CoreDataManager.instance.saveContext()
                self.navigationController?.popViewController(animated: true)
            } else {
                presentAlertOfRequirements()
            }
        } else {
            if newRewardArray.count >= minimumRewardsInList {
                let newRewardList = RewardList()
                newListName = listNameField.text ?? ""
                newRewardList.name = newListName
                newRewardList.rewards = newRewardArray
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
    
    
    @IBAction func newRewardFieldCompleted(_ sender: UITextField) {
        if let reward = sender.text {
            if reward != "" {
                if let listToEdit = rewardList {
                    listToEdit.rewards.append(reward)
                } else {
                    newRewardArray.append(reward)
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
