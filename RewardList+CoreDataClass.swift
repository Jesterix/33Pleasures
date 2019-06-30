//
//  RewardList+CoreDataClass.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 28/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//
//

import Foundation
import CoreData

@objc(RewardList)
public class RewardList: NSManagedObject {
    convenience init() {
        self.init(entity: CoreDataManager.instance.entityForName(entityName: "RewardList"), insertInto: CoreDataManager.instance.persistentContainer.viewContext)
    }
}
