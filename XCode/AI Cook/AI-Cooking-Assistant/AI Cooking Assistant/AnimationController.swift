//
//  AnimationController.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/21/23.
//

import Foundation
import UIKit

class AnimationController {
    var imageView: UIImageView
    var images: [UIImage]
    
    init(imageView: UIImageView, images: [UIImage]) {
        self.imageView = imageView
        self.images = images
    }
    
    func setLastImage() {
        imageView.image = images.last
    }
    
    func setRandomImage() {
        let index = Int.random(in: 0..<(images.count - 1))
        imageView.image = images[index]
    }
    
    
}
