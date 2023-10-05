//
//  ViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/6/23.
//

import UIKit
import ImageIO
class HomeViewController: UIViewController{
    
    @IBOutlet var imageView1: UIImageView!
    @IBOutlet var imageView2: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let gifImage = UIImage(named: "Peachy-Talk1x") {
            imageView1.image = gifImage
        } else {
            print("GIF not found in asset catalog")
        }
    }
}


extension UIImage {

    public class func gif(data: Data) -> UIImage? {
        guard let source = CGImageSourceCreateWithData(data as CFData, nil) else {
            print("Gif data is corrupted")
            return nil
        }

        return UIImage.animatedImageWithSource(source)
    }

    private class func animatedImageWithSource(_ source: CGImageSource) -> UIImage? {
        let count = CGImageSourceGetCount(source)
        var images = [UIImage]()
        var duration = 0.0

        for i in 0..<count {
            if let cgImage = CGImageSourceCreateImageAtIndex(source, i, nil) {
                let uiImage = UIImage(cgImage: cgImage)
                images.append(uiImage)
                let frameDuration = UIImage.frameDuration(from: source, at: i)
                duration += frameDuration
            }
        }

        return UIImage.animatedImage(with: images, duration: duration)
    }

    private class func frameDuration(from source: CGImageSource, at index: Int) -> Double {
        guard let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil) else {
            return 0.0
        }

        guard let gifProperties = (cfProperties as NSDictionary)[kCGImagePropertyGIFDictionary as String] as? NSDictionary else {
            return 0.0
        }

        let unclampedDelayTime = gifProperties[kCGImagePropertyGIFUnclampedDelayTime as String] as? NSNumber
        let delayTime = gifProperties[kCGImagePropertyGIFDelayTime as String] as? NSNumber

        return (unclampedDelayTime?.doubleValue ?? delayTime?.doubleValue ?? 0.0)
    }

}
