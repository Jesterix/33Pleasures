//
//  WheelViewController.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 22/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import UIKit
import TTFortuneWheel

//VC responsible for user interaction with fortune wheel
class WheelViewController: UIViewController {

    var wheelSlicesAmount:Int?
    var rewardList : [Reward] = []
    @IBOutlet weak var resultLabel: UILabel!
    
    var fortuneWheel : TTFortuneWheel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        resultLabel.text = "Spin and win your reward!"

        var slices = [CustomWheelSlice]()
        if let wheelSlices = wheelSlicesAmount {
            for i in 0...wheelSlices - 1 {
                slices.append(CustomWheelSlice(title: rewardList[i].name ?? "no value"))
            }
        }

        let wheelRadius : CGFloat = (view.frame.width - 50) / 2
        let wheelPosition : CGPoint = CGPoint(x: view.center.x - wheelRadius, y: view.center.y - wheelRadius)
        let frame = CGRect(origin: wheelPosition, size: CGSize(width: wheelRadius * 2, height: wheelRadius * 2))
        
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
                    self.resultLabel.text = self.rewardList[rand].name
                    self.rewardList[rand].wasSelected += 1
                    CoreDataManager.instance.saveContext()
                }
            }
        }
    }

}
