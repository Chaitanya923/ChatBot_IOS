//
//  ChatMessages+CoreDataProperties.swift
//  Chatbot
//
//  Created by neosoft on 13/04/22.
//
//

import Foundation
import CoreData


extension ChatMessages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatMessages> {
        return NSFetchRequest<ChatMessages>(entityName: "ChatMessages")
    }

    @NSManaged public var botname: String?
    @NSManaged public var message: String?
    @NSManaged public var date: Date?
    @NSManaged public var frombot: Bool

}

extension ChatMessages : Identifiable {

}
