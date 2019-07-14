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
    var tableDataSource : [String] = []
    var table: UITableView?
    
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
//здесь добавить реализацию делегата таблицы
//    а во вью добавить тулбар с кнопкой ДОНЕ (через билдер)
    
    func reloadData(){
        table?.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init()
        cell.textLabel?.text = tableDataSource[indexPath.row]
        return cell
    }

}
