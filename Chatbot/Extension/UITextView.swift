//
//  UITextView.swift
//  Chatbot
//
//  Created by neosoft on 22/04/22.
//

import UIKit

extension UITextView {
    func adjustUITextViewHeight() {
        self.translatesAutoresizingMaskIntoConstraints = true
        self.sizeToFit()
        self.isScrollEnabled = false
    }
}
