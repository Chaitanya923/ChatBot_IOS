//
//  DialogueListingViewController.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit
import CoreData


class DialogueListingViewController: UIViewController {
    
    lazy var viewmodel : DialogueListViewModel = DialogueListViewModel()
    
    static func LoadFromNib() -> UIViewController {
        return DialogueListingViewController(nibName: "DialogueListingViewController", bundle: nil)
    }
    
    @IBOutlet weak var DialogueListingTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NavBarSetUp()
        TableData()
        BindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewmodel.FetchFromCoreData()
    }
    func  BindData() {
        viewmodel.fetchstatus.bind(listener: { responsed in
            switch responsed {
            case true:
                self.DialogueListingTable.reloadData()
            case false:
                return
            }
        })
        
    }

    
    func alerterros (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    func NavBarSetUp(){
        title = "CHATBOT"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "8EDFFA")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(AddBot))
    }
    
    @objc func AddBot() {
        //Variable to store alertTextField
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add Bot", message: "", preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.systemGray5
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name"
            
            //Copy alertTextField in local variable to use in current block of code
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Submit", style: .default) { action in
            if ((textField.text?.isEmpty) != true) {
                self.viewmodel.CheckExistenceOfBot(textField.text!){ num in
                    switch num{
                    case true:
                        self.alerterros("Invalid Bot Name", "Bot Name already exist")
                    case false:
                        self.viewmodel.SaveToCoreData(textField.text!)
                    }
                }
            }
        }
        
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
}

extension DialogueListingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func TableData() {
        DialogueListingTable.delegate = self
        DialogueListingTable.dataSource = self
        DialogueListingTable.register(UINib(nibName: "DialogueListingTableViewCell", bundle: nil), forCellReuseIdentifier: "DialogueListingCell")
        DialogueListingTable.tableFooterView = UIView(frame: .zero)    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todos = viewmodel.fetchedRC?.fetchedObjects else { return 0 }
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = viewmodel.fetchedRC.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogueListingCell", for: indexPath) as! DialogueListingTableViewCell
        
        cell.UpdateCell(todo.name ?? "Bot", todo.newtext ?? "No Message", "\(Date().offset(from: todo.newdate!)) ago")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = viewmodel.fetchedRC.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        self.navigationController?.pushViewController(ChatViewController.LoadFromNib(todo.name!), animated: true)
    }
    
}


