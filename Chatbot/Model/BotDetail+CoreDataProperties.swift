//
//  BotDetail+CoreDataProperties.swift
//  Chatbot
//
//  Created by neosoft on 13/04/22.
//
//

import Foundation
import CoreData


extension BotDetail {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BotDetail> {
        return NSFetchRequest<BotDetail>(entityName: "BotDetail")
    }

    @NSManaged public var name: String?
    @NSManaged public var createdate: Date?
    @NSManaged public var newdate: Date?
    @NSManaged public var newtext: String?

}

extension BotDetail : Identifiable {

}
