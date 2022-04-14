//
//  DialogueListingTableViewCell.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit

class DialogueListingTableViewCell: UITableViewCell {

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var bot_name: UILabel!
    @IBOutlet weak var bot_message: UILabel!
    @IBOutlet weak var message_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView()  {
        mainview.layer.cornerRadius = 7
        self.selectionStyle = .none
    }
    
    func UpdateCell(_ n : String,_ m : String,_ t : String) {
        bot_name.text = n
        bot_message.text = m
        message_time.text = t
    }
}
