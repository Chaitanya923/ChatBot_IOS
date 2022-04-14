//
//  DialogueListViewModel.swift
//  Chatbot
//
//  Created by neosoft on 14/04/22.
//

import UIKit
import CoreData


class DialogueListViewModel {
    var fetchstatus : Observable<Bool> = Observable(false)
    var fetchedRC: NSFetchedResultsController<BotDetail>!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var bot_Name = ""
    func FetchFromCoreData() {
      let request = BotDetail.fetchRequest() as NSFetchRequest<BotDetail>
        let sort = NSSortDescriptor(key: #keyPath(BotDetail.newdate), ascending: false)
          request.sortDescriptors = [sort]
      do {
        fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try fetchedRC.performFetch()
        fetchstatus.value = true
        //self.DialogueListingTable.reloadData()
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    func SaveToCoreData(_ t : String) {
        let todo = BotDetail(context: context)
            
        todo.name = t
        todo.createdate = Date()
        todo.newdate = Date()
        todo.newtext = " "
        appDelegate.saveContext()
        FetchFromCoreData()
    }
    
    func CheckExistenceOfBot(_ t : String,completionhandler: @escaping ((Bool) -> Void)) {
        let request = BotDetail.fetchRequest() as NSFetchRequest<BotDetail>
        request.predicate = NSPredicate(format: "name == %@", t)
          let sort = NSSortDescriptor(key: #keyPath(BotDetail.newdate), ascending: false)
            request.sortDescriptors = [sort]
        do {
          fetchedRC = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
          try fetchedRC.performFetch()
            guard let todos = fetchedRC.fetchedObjects else { return }
            print("count : \(todos.count)")
            if (todos.count > 0){
                completionhandler(true)
            }
            else{
                completionhandler(false)
            }
        } catch let error as NSError {
          print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
}
