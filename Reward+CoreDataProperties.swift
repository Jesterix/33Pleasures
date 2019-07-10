//
//  Reward+CoreDataProperties.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 10/07/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//
//

import Foundation
import CoreData


extension Reward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reward> {
        return NSFetchRequest<Reward>(entityName: "Reward")
    }

    @NSManaged public var category: Int16
    @NSManaged public var name: String?
    @NSManaged public var rewardList: NSSet?

}

// MARK: Generated accessors for rewardList
extension Reward {

    @objc(addRewardListObject:)
    @NSManaged public func addToRewardList(_ value: RewardList)

    @objc(removeRewardListObject:)
    @NSManaged public func removeFromRewardList(_ value: RewardList)

    @objc(addRewardList:)
    @NSManaged public func addToRewardList(_ values: NSSet)

    @objc(removeRewardList:)
    @NSManaged public func removeFromRewardList(_ values: NSSet)

}
