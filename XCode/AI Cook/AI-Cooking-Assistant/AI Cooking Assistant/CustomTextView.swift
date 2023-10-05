//
//  CustomTextView.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/29/23.
//

import Foundation
import UIKit
import QuartzCore
class CustomTextView: UITextView {
  let customGray = UIColor.lightGray.withAlphaComponent(0.6)
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    self.layer.borderColor = UIColor.lightGray.withAlphaComponent(0.4).cgColor
      //CGColor?
    self.layer.borderWidth = 0.6
      //CGFloat
    self.layer.cornerRadius = 5.0
      //CGFloat
    self.layer.masksToBounds = true
      //Bool
    self.contentInset = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
  }
}
