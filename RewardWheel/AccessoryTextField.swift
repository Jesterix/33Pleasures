//
//  AccessoryTextField.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 13/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

//custom text field which has VC to handle custom accessoryView as a property
class AccessoryTextField: UITextField, DoneButtonToHide {

    var accessoryVC : CustomInputVC?
    
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
    }
    
    func doneTapped() {
        self.resignFirstResponder()
    }
}
