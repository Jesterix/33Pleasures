//
//  RewardList+CoreDataProperties.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 28/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//
//

import Foundation
import CoreData


extension RewardList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<RewardList> {
        return NSFetchRequest<RewardList>(entityName: "RewardList")
    }

    @NSManaged public var name: String?
    @NSManaged public var rewards: [String]

}
