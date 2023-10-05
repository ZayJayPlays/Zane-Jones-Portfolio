//
//  StepsViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/6/23.
//

import UIKit

class StepsViewController: UIViewController {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var activityLabel: UILabel!
    
    @IBOutlet weak var ingredientListStack: UIStackView!
    @IBOutlet weak var ingredientsTitleLabel: UILabel!
    @IBOutlet weak var ingredientsLabel: UILabel!
    
    @IBOutlet weak var stepNumberStack: UIStackView!
    @IBOutlet weak var stepNumberLabel: UILabel!
    @IBOutlet weak var instructionsLabel: UILabel!
    
    @IBOutlet var nextButton: UIButton!
    
    
    @IBOutlet weak var voiceControlStack: UIStackView!
    
    @IBOutlet weak var animatedImage: UIImageView!
    
    var indexBeingDisplayed: Int = 0
    let shared = ResponseObject.shared
    
    var speechSynthesizer: SpeechSynthesizer?
    let voiceRecognizer = VoiceRecognizer()
    
    let userDefaults = UserDefaults.standard
    
    var animationController: AnimationController?
    let imageArray: [UIImage] = [UIImage(named: "Red"), UIImage(named: "Blue"), UIImage(named: "Green"), UIImage(named: "Cactus"), UIImage(named: "Purple")].compactMap { $0 }
    
    var speechActivated: Bool {
        userDefaults.bool(forKey: "IsSpeechEnabled")
    }
    var voiceActivated: Bool {
        userDefaults.bool(forKey: "IsVoiceControlEnabled")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateUI), name: NotificationManager.didReceiveNetworkResponse, object: nil)
        instructionsLabel.lineBreakMode = .byWordWrapping // or .byCharWrapping
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        
        ingredientListStack.isHidden = true
        stepNumberStack.isHidden = true
        
        activityIndicator.startAnimating()
        activityIndicator.hidesWhenStopped = true
        
        voiceControlStack.isHidden = true
        
        voiceRecognizer.stepsController = self
        //voiceRecognizer.startListening()
        
        speechSynthesizer = SpeechSynthesizer(stepsController: self)
        animationController = AnimationController(imageView: animatedImage, images: imageArray)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if userDefaults.bool(forKey: "IsVoiceControlEnabled") {
            voiceRecognizer.startListening()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationManager.didReceiveNetworkResponse, object: nil)
    }
    
    @objc func updateUI() {
        if indexBeingDisplayed == 0 {
            activityIndicator.stopAnimating()
            activityLabel.isHidden = true
            
            voiceControlStack.isHidden = true
            ingredientListStack.isHidden = false
            stepNumberStack.isHidden = true
            ingredientsTitleLabel.text = "Ingredients"
            ingredientsLabel.text = shared.response[indexBeingDisplayed]
            processSpeech()
            animationController?.setRandomImage()
            
            //nextOrStartButtonTapped([]) //For testing ease; uncomment to press Start button immediately after load. nextOrStartButtonTapped's sender must be changed to Any.
        } else {
            voiceControlStack.isHidden = false
            ingredientListStack.isHidden = true
            stepNumberStack.isHidden = false
            if let firstCharacter = shared.response[indexBeingDisplayed].first {
                // Check if the second character is also a number
                if shared.response[indexBeingDisplayed].count > 1,
                   let secondCharacter = shared.response[indexBeingDisplayed].dropFirst().first,
                   CharacterSet.decimalDigits.contains(secondCharacter.unicodeScalars.first!) {
                    
                    // Append the second character to the first one
                    let combinedString = "Step #\(firstCharacter)\(secondCharacter)"
                    stepNumberLabel.text = combinedString
                } else {
                    // Only the first character is a number
                    stepNumberLabel.text = "Step #\(firstCharacter)"
                }
            }
            instructionsLabel.text = shared.response[indexBeingDisplayed]
            
            instructionsLabel.sizeToFit()
            processSpeech()
            
        }
        
        if indexBeingDisplayed == shared.response.count - 1 {
            nextButton.isHidden = true
        } else {
            nextButton.isHidden = false
        }
    }
    
    @IBAction func nextOrStartButtonTapped(_ sender: UIButton) {
        performNext()
    }
    
    func performNext() {
        if indexBeingDisplayed != shared.response.count - 1 {
            indexBeingDisplayed += 1
            updateUI()
        }
    }
    
    @IBAction func previousButtonTapped(_ sender: UIButton) {
        performPrevious()
    }
    
    func performPrevious() {
        if indexBeingDisplayed != 0 {
            indexBeingDisplayed -= 1
            updateUI()
            
        }
    }
    
    func processSpeech() {
        endSpeech()
        if indexBeingDisplayed > 0 {
            beginSpeech()
        }
    }
    
    func beginSpeech() {
        guard speechActivated && indexBeingDisplayed > 0 else {return}
        animationController?.setLastImage()
        
        let firstCharacter = shared.response[indexBeingDisplayed].first
        if let firstChar = firstCharacter, CharacterSet.decimalDigits.contains(firstChar.unicodeScalars.first!) {
            // The first character is a digit
            stepNumberLabel.isHidden = indexBeingDisplayed == 0 ? true : false
            speechSynthesizer?.beginSpeech("Step \(shared.response[indexBeingDisplayed])")
        } else {
            // The first character is not a digit
            stepNumberLabel.isHidden = true
            speechSynthesizer?.beginSpeech("\(shared.response[indexBeingDisplayed])")
        }
        
    }
    
    func endSpeech() {
        speechSynthesizer!.stopSpeech()
    }
    
    func doneTalking() {
        animationController?.setRandomImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        endSpeech()
        voiceRecognizer.stopListening()
        indexBeingDisplayed = 0
    }
    
}
