//
//  CustomInputVC.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 13/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class CustomInputVC: UIViewController {

    var frame : CGRect?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    override func loadView() {
        self.view = CustomInputView(frame: frame!)
    }
    
    func view() -> CustomInputView {
        return self.view as! CustomInputView
    }

    

}
