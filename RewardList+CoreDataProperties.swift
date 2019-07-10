//
//  RewardList+CoreDataProperties.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 09/07/2019.
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
    @NSManaged public var rewards: Set<Reward>//NSSet?

}

// MARK: Generated accessors for rewards
extension RewardList {

    @objc(addRewardsObject:)
    @NSManaged public func addToRewards(_ value: Reward)

    @objc(removeRewardsObject:)
    @NSManaged public func removeFromRewards(_ value: Reward)

    @objc(addRewards:)
    @NSManaged public func addToRewards(_ values: NSSet)

    @objc(removeRewards:)
    @NSManaged public func removeFromRewards(_ values: NSSet)

}
