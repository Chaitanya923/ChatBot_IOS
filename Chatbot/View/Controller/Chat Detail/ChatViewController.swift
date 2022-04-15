//
//  ChatViewController.swift
//  Chatbot
//
//  Created by neosoft on 12/04/22.
//

import UIKit
import CoreData

var Bot_name : String = ""
var rowcount = 0

class ChatViewController: UIViewController {
    
    lazy var viewmodel : ChatDetailViewModel = ChatDetailViewModel()
    
    @IBOutlet weak var MessageTextField: UITextView!
    
    static func LoadFromNib(_ botname : String) -> UIViewController{
        Bot_name = botname
        return ChatViewController(nibName: "ChatViewController", bundle: nil)
    }
    
    @IBOutlet weak var ChatTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBarSetUp()
        TableData()
        BindData()
        
        MessageTextField.layer.cornerRadius = MessageTextField.frame.height/2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel.FetchFromCoreData()
        scrollToBottom()
    }
    
    func BindData() {
        viewmodel.status.bind { responsed in
            switch responsed {
            case true:
                DispatchQueue.main.async {
                    self.MessageTextField.text = ""
                    self.ChatTable.reloadData()
                    self.scrollToBottom()
                }
            case false:
                return
            }
        }
    }
    
    @IBAction func SendTapped(_ sender: UIButton) {
        if(MessageTextField.text!.isEmpty != true){
            viewmodel.FetchAndUpdateCoreData(MessageTextField.text!)
            viewmodel.SaveMessage(MessageTextField.text!, false)
            let num = Int.random(in: 0...6)
            viewmodel.FetchAndUpdateCoreData(viewmodel.arraymessage[num])
            viewmodel.SaveMessage(viewmodel.arraymessage[num], true)
        }
    }
    
    
    func NavBarSetUp() {
        title = Bot_name
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "8EDFFA")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
}

extension ChatViewController: UITableViewDelegate, UITableViewDataSource{
    
    func TableData() {
        ChatTable.delegate = self
        ChatTable.dataSource = self
        ChatTable.register(UINib(nibName: "UserTableViewCell", bundle: nil), forCellReuseIdentifier: "UserCell")
        ChatTable.register(UINib(nibName: "BotTableViewCell", bundle: nil), forCellReuseIdentifier: "BotCell")
        ChatTable.tableFooterView = UIView(frame: .zero)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todos = viewmodel.fetchedRC2?.fetchedObjects else { return 0 }
        rowcount = todos.count
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = viewmodel.fetchedRC2.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        switch todo.frombot{
        case true:
            let cell = tableView.dequeueReusableCell(withIdentifier: "BotCell", for: indexPath) as! BotTableViewCell
            cell.UpdateCell(todo.message!, "\(Date().offset(from: todo.date!)) ago")
            return cell
        case false:
            let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as!
                UserTableViewCell
            cell.UpdateCell(todo.message!, "\(Date().offset(from: todo.date!)) ago")
            return cell
        }
    }
    
 
    func scrollToBottom(){
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: rowcount-1, section: 0)
            if (rowcount > 0){
            self.ChatTable.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    }
}

extension ChatViewController : NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        //print("index = \(indexPath) & new = \(newIndexPath)")
            let index = IndexPath(row: indexPath?.row ?? rowcount-1, section: indexPath?.section ?? 0) ?? (newIndexPath ?? nil)
            print("row \(rowcount)")
            guard let cellIndex = index else { return }
            switch type {
                case .insert:
                    ChatTable.insertRows(at: [cellIndex], with: .fade)
                    rowcount = rowcount + 1
                default:
                    break
            }
    }
  }
