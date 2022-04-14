//
//  BotTableViewCell.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit

class BotTableViewCell: UITableViewCell {

    @IBOutlet weak var mainview: UIView!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var message_time: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
 
    func setupView() {
        mainview.layer.cornerRadius = 7
    }
    
    func UpdateCell(_ m : String , _ t : String) {
        message.text = m
        message_time.text = t
    }
}
