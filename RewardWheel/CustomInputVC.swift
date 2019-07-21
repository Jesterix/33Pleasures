//
//  CustomInputVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 13/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class CustomInputVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var frame : CGRect?
    var tableDataSource : [Reward] = []
    var table : UITableView?
    var textViewDelegate : AccessoryTextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func loadView() {
        self.view = CustomInputView(frame: frame!)
        view().tableView.delegate = self
        view().tableView.dataSource = self
        table = view().tableView
    }
    
    func view() -> CustomInputView {
        return self.view as! CustomInputView
    }
    
    func reloadData(){
        table?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = tableDataSource[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textViewDelegate?.text = tableDataSource[indexPath.row].name
        self.view().categoryControl.selectedSegmentIndex = Int(tableDataSource[indexPath.row].category)
    }
}
