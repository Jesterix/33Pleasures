//
//  AccessoryTextField.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 13/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class AccessoryTextField: UITextField {

    var accessoryVC : CustomInputVC?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
//        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(){
        let accessoryFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height * 4)
        accessoryVC = CustomInputVC()
        accessoryVC?.frame = accessoryFrame
        self.inputAccessoryView = accessoryVC?.view()
    }

    
}
