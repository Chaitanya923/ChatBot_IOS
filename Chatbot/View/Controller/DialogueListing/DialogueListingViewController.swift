//
//  DialogueListingViewController.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit
import CoreData


class DialogueListingViewController: UIViewController {
    
    lazy var viewModel : DialogueListViewModel = DialogueListViewModel()
    
    
    @IBOutlet weak var dialogueListingTable: UITableView!
    
    static func loadFromNib() -> UIViewController {
            return DialogueListingViewController(nibName: "DialogueListingViewController", bundle: nil)
        }

    override func viewDidLoad() {
        super.viewDidLoad()
        navBarSetUp()
        tableData()
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.FetchFromCoreData()
    }
    
    func  bindData() {
        viewModel.fetchstatus.bind(listener: { responsed in
            switch responsed {
            case true:
                self.dialogueListingTable.reloadData()
            case false:
                return
            }
        })
        
    }
    
    func alertError (_ title:String,_ message : String){
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
    }
    
    func navBarSetUp(){
        title = "CHATBOT"
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.backgroundColor = UIColor(hexFromString: "8EDFFA")
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white,NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 25)]
        //self.navigationController?.navigationBar.barTintColor = UIColor.white
        self.navigationController?.navigationBar.tintColor = UIColor.black
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBot))
    }
    
    @objc func addBot() {
        var textField = UITextField()
    
        let alert = UIAlertController(title: "Add Bot", message: "", preferredStyle: .alert)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor.systemGray5
        
        alert.addTextField { alertTextField in
            alertTextField.placeholder = "Name"
            textField = alertTextField
        }
        
        let action = UIAlertAction(title: "Submit", style: .default) { action in
            if ((textField.text?.isEmpty != true && textField.text!.ValidBotName()) ) {
                self.viewModel.CheckExistenceOfBot(textField.text!){ num in
                    switch num{
                    case true:
                        self.alertError("Invalid Bot Name", "Bot Name already exist")
                    case false:
                        self.viewModel.SaveToCoreData(textField.text!)
                    }
                }
            }
            else{
                self.alertError("Invalid Botname", "Bot name must have alphabets only. Numbers, special character and Whitespace are not allowed ")
            }
            
        }
        
        alert.addAction(action)
        present(alert, animated: true) {
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
            alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            
        }
    }
    @objc func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }}

extension DialogueListingViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableData() {
        dialogueListingTable.delegate = self
        dialogueListingTable.dataSource = self
        dialogueListingTable.register(UINib(nibName: "DialogueListingTableViewCell", bundle: nil), forCellReuseIdentifier: "DialogueListingCell")
        dialogueListingTable.tableFooterView = UIView(frame: .zero)    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let bots = viewModel.fetchedRC?.fetchedObjects else { return 0 }
        return bots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let bot = viewModel.fetchedRC.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        let cell = tableView.dequeueReusableCell(withIdentifier: "DialogueListingCell", for: indexPath) as! DialogueListingTableViewCell
        cell.UpdateCell(bot.name ?? "Bot", bot.newtext ?? "No Message", "\(Date().offset(from: bot.newdate!)) ago")
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bot = viewModel.fetchedRC.object(at: IndexPath(row: indexPath.row, section: indexPath.section))
        self.navigationController?.pushViewController(ChatViewController.loadFromNib(bot.name!), animated: true)
    }
    
}


