//
//  WheelViewController.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 22/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import TTFortuneWheel

class WheelViewController: UIViewController {

    var wheelSlicesAmount:Int?
    var rewardList = [""]
    @IBOutlet weak var resultLabel: UILabel!
    
    var fortuneWheel : TTFortuneWheel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultLabel.text = "Spin and win your reward!"

        var slices = [CustomWheelSlice]()
        if let wheelSlices = wheelSlicesAmount {
            for i in 0...wheelSlices - 1 {
                slices.append(CustomWheelSlice(title: rewardList[i]))
            }
        }

        let frame = CGRect(origin: (CGPoint(x: 25, y: view.frame.height/4)), size: CGSize(width: view.frame.width - 50, height: view.frame.width - 50))
        
        fortuneWheel = TTFortuneWheel(frame: frame, slices:slices)
        fortuneWheel!.equalSlices = true
        fortuneWheel!.slices.enumerated().forEach { (pair) in
            let slice = pair.element as! CustomWheelSlice
            let offset = pair.offset
            if fortuneWheel!.slices.count % 4 != 1 {
                switch offset % 4 {
                case 0: slice.style = .firstColor
                case 1: slice.style = .fourthColor
                case 2: slice.style = .secondColor
                case 3: slice.style = .thirdColor
                default: slice.style = .secondColor
                }
            } else {
                switch offset % 5 {
                case 0: slice.style = .firstColor
                case 1: slice.style = .fourthColor
                case 2: slice.style = .secondColor
                case 3: slice.style = .thirdColor
                case 4: slice.style = .fourthColor
                default: slice.style = .secondColor
                }
            }
            
        }
        self.view.addSubview(fortuneWheel!)
    }
    

    @IBAction func spinTapped(_ sender: UIButton) {
        if fortuneWheel != nil {
            fortuneWheel!.startAnimating()
            
            var rand = 0
            if let amount = wheelSlicesAmount {
                rand = Int(arc4random_uniform(UInt32(amount)))
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                self.fortuneWheel!.startAnimating(finishIndex: rand) { (finished) in
                    print(finished)
                    print(rand)
                    self.resultLabel.text = self.rewardList[rand]
                }
            }
        }
    }

}
