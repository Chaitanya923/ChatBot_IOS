//
//  UserTableViewCell.swift
//  Chatbot
//
//  Created by neosoft on 11/04/22.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var messageTime: UILabel!
    @IBOutlet weak var message: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpView()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setUpView()  {
        mainView.layer.cornerRadius = 7
    }
    
    func updateCell(_ m : String , _ t : String) {
        message.text = m
        //while (true) {
            messageTime.text = t

        //}
    }
}
