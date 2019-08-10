//
//  FilterVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 04/08/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import CoreData

protocol DataDelegate {
    func getData(data:[Reward])
}

//vc for working with all rewards in CoreData, filtering them and adding to reward lists with ease
class FilterVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    var rewards : [Reward] = []//this is an array for all Rewards in database
    var fetchResultController = NSFetchedResultsController<Reward>()
    var rewardsToShow : [Reward] = []//this is an array for filtering
    var allCellsAreSelected = false
    var dataDelegate : DataDelegate?

    @IBOutlet weak var filterTableView: UITableView!
    
    @IBOutlet weak var pricelessSwitch: UISwitch!
    @IBOutlet weak var cheapSwitch: UISwitch!
    @IBOutlet weak var normalSwitch: UISwitch!
    @IBOutlet weak var expensiveSwitch: UISwitch!
    
    @IBOutlet weak var selectButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

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
        
        //setting up table datasource
        rewardsToShow = rewards
        
        //other setups
        filterTableView.allowsMultipleSelection = true
        checkSelectButtonState()
    }
    
    //this func is for translating Int16 to certain background colors for setting colors of different categories of rewards
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
        return rewardsToShow.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = rewardsToShow[indexPath.row].name
        cell.textLabel?.textColor = setColorFromInt16(value: rewardsToShow[indexPath.row].category)
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: UITableViewRowAction.Style.default, title: "delete") { (rowAction, indexPath) in
            //delete row from table and from CoreData
            print("delete row")
            let context = CoreDataManager.instance.persistentContainer.viewContext
            for reward in self.rewards {
                if reward.name == self.rewardsToShow[indexPath.row].name {
                    context.delete(reward)
                    CoreDataManager.instance.saveContext()
                    break
                }
            }
            self.rewardsToShow.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        deleteAction.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
        return [deleteAction]
    }
    
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        allCellsAreSelected = false
        checkSelectButtonState()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //checking selection state on each row to modify select/deselect button
        var numberOfCells = 0
        var numberOfSelected = 0
        for section in 0...tableView.numberOfSections - 1 {
            for row in 0...tableView.numberOfRows(inSection: section) - 1 {
                if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {
                    numberOfCells += 1
                    if cell.isSelected {
                        numberOfSelected += 1
                    }
                }
            }
        }
        if numberOfCells == numberOfSelected {
            allCellsAreSelected = true
            checkSelectButtonState()
        }
    }
    
    func checkSelectButtonState(){
        if allCellsAreSelected {
            selectButton.setTitle("Deselect all", for: .normal)
        } else {
            selectButton.setTitle("Select all", for: .normal)
        }
    }
    
    
    @IBAction func selectAllTapped(_ sender: UIButton) {
        for section in 0...filterTableView.numberOfSections - 1 {
            for row in 0...filterTableView.numberOfRows(inSection: section) - 1 {
                if allCellsAreSelected {
                    filterTableView.deselectRow(at: IndexPath(row: row, section: section), animated: false)
                } else {
                    filterTableView.selectRow(at: IndexPath(row: row, section: section), animated: false, scrollPosition: .none)
                }
            }
        }
        allCellsAreSelected = !allCellsAreSelected
        checkSelectButtonState()
    }
    
    
    @IBAction func addAllSelectedToListTapped(_ sender: UIButton) {
        var rewardsToAdd : [Reward] = []
        for section in 0...filterTableView.numberOfSections - 1 {
            for row in 0...filterTableView.numberOfRows(inSection: section) - 1 {
                if let cell = filterTableView.cellForRow(at: IndexPath(row: row, section: section)) {
                    if cell.isSelected {
                        rewardsToAdd.append(rewardsToShow[row])
                    }
                }
            }
            self.dataDelegate?.getData(data: rewardsToAdd)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func filterData(){
        rewardsToShow = []
        if pricelessSwitch.isOn {
            rewardsToShow.append(contentsOf: rewards.filter { $0.category == Int16(0)})
        }
        if cheapSwitch.isOn {
            rewardsToShow.append(contentsOf: rewards.filter { $0.category == Int16(1)})
        }
        if normalSwitch.isOn {
            rewardsToShow.append(contentsOf: rewards.filter { $0.category == Int16(2)})
        }
        if expensiveSwitch.isOn {
            rewardsToShow.append(contentsOf: rewards.filter { $0.category == Int16(3)})
        }
        filterTableView.reloadData()
    }

    @IBAction func pricelessChanged(_ sender: UISwitch) {
        filterData()
    }
    @IBAction func cheapChanged(_ sender: UISwitch) {
        filterData()
    }
    @IBAction func normalChanged(_ sender: UISwitch) {
        filterData()
    }
    @IBAction func expensiveChanged(_ sender: UISwitch) {
        filterData()
    }
    
    
}
