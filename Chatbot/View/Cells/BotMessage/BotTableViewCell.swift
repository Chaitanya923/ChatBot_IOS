//
//  BotTableViewCell.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit

class BotTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageTime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setUpView() {
        mainView.layer.cornerRadius = 7
    }
    
    func updateCell(_ m : String , _ t : String) {
        message.text = m
        messageTime.text = t
    }
}
