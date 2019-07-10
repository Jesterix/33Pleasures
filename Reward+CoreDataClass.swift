//
//  Reward+CoreDataClass.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 08/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reward)
public class Reward: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "Reward"), insertInto: CoreDataManager.instance.persistentContainer.viewContext)
    }
}


