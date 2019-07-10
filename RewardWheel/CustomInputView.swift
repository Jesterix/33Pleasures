//
//  CustomInputView.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 09/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit

class CustomInputView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var categoryControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit(){
        Bundle.main.loadNibNamed("CustomInputView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
