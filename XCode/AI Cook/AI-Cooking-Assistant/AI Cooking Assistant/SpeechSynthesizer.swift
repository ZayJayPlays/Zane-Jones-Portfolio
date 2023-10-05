//
//  SpeechSynthesizer.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/12/23.
//

import Foundation
import AVKit
import AVFoundation

class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    let speechSynthesizer = AVSpeechSynthesizer()
    var stepsController: StepsViewController
    var currentUtterance: AVSpeechUtterance?
    
    init(stepsController: StepsViewController) {
        do {
            self.stepsController = stepsController
            super.init()
            speechSynthesizer.delegate = self
            try AVAudioSession.sharedInstance().setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("An error occurred setting up audio session: \(error)")
        }
    }
    
    func beginSpeech(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = UserDefaults.standard.float(forKey: "SpeechSpeed")
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        utterance.pitchMultiplier = 1.2
        currentUtterance = utterance
        
        
        speechSynthesizer.speak(utterance)
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if let current = currentUtterance, utterance == current {
            stepsController.doneTalking()
        }
    }
}

