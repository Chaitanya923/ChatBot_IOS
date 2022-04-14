//
//  ChatDetailViewModel.swift
//  Chatbot
//
//  Created by neosoft on 14/04/22.
//

import UIKit
import CoreData

class ChatDetailViewModel {
    
    var status : Observable<Bool> = Observable(false)
    
    var arraymessage = ["Hello,How are you?","What's Up?","Hey!Take a Break.","Good Day!","Hey!","Yup","Bravo"]
    
    var fetchedRC1: NSFetchedResultsController<BotDetail>!
    var fetchedRC2: NSFetchedResultsController<ChatMessages>!
    private var appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func FetchAndUpdateCoreData(_ t : String) {
      let request = BotDetail.fetchRequest() as NSFetchRequest<BotDetail>
        let sort = NSSortDescriptor(key: #keyPath(BotDetail.newdate), ascending: false)
          request.sortDescriptors = [sort]
        request.predicate = NSPredicate(format: "name == %@", Bot_name)
      do {
        fetchedRC1 = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try fetchedRC1.performFetch()
        let list = fetchedRC1.object(at: IndexPath(row: 0, section: 0))
        list.setValue(Date(), forKey: "newdate")
        list.setValue(t, forKey: "newtext")
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    func FetchFromCoreData() {
        let request = ChatMessages.fetchRequest() as NSFetchRequest<ChatMessages>
        request.predicate = NSPredicate(format: "botname == %@", Bot_name)
        let sort = NSSortDescriptor(key: #keyPath(ChatMessages.date), ascending: true)
        request.sortDescriptors = [sort]
          do {
            
            fetchedRC2 = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            try fetchedRC2.performFetch()
            //self.ChatTable.reloadData()
            //fetchedRC2.delegate = self
            status.value = true
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            }
        
    }
    
    func SaveMessage(_ t : String , _ stat : Bool) {
        let todo = ChatMessages(context: context)
            
        todo.message = t
        todo.botname = Bot_name
        todo.date = Date()
        todo.frombot = stat
        appDelegate.saveContext()
        FetchFromCoreData()
        
    }

}

enum chatstatus {
    case fetched
    case send
    case fail
}
