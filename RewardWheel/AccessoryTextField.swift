//
//  AccessoryTextField.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 13/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

protocol TransitionDelegate {
    func transite()
}

//custom text field which has VC to handle custom accessoryView as a property
class AccessoryTextField: UITextField {

    var accessoryVC : CustomInputVC?
    var filterButton : UIButton?
    var transitionDelegate : TransitionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup(){
        let accessoryFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 8)
        accessoryVC = CustomInputVC()
        accessoryVC?.frame = accessoryFrame
        self.inputAccessoryView = accessoryVC?.view()
        accessoryVC?.view().delegate = self
        accessoryVC?.textViewDelegate = self
        filterButtonSetup()
    }
    
    func filterButtonSetup(){
        let button = UIButton(type: .system)
        button.setTitle("📖", for: .normal)
        button.frame = CGRect(x: self.bounds.maxX * 0.9, y: 0, width: self.bounds.height, height: self.bounds.height)
        button.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        self.addSubview(button)
        filterButton = button
    }
    
    @objc func filterButtonTapped(){
        self.transitionDelegate?.transite()
    }
}

extension AccessoryTextField : DoneButtonToHide {
    func doneTapped() {
        self.resignFirstResponder()
        accessoryVC?.tableDataSource = []
        accessoryVC?.view().categoryControl.selectedSegmentIndex = 0
        accessoryVC?.reloadData()
    }
}
