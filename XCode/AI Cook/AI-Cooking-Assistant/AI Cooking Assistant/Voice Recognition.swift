//
//  Voice Recognition.swift
//  AI Cooking Assistant
//
//  Created by Zane Jones on 9/12/23.
//

import Foundation
import Speech

class VoiceRecognizer {
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    
    weak var stepsController: StepsViewController?
    
    
    init() {
        // Request authorization for speech recognition
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if authStatus == .authorized {
                print("Speech recognition authorization granted.")
            }
        }
    }
    
    func startListening() {
        do {
            try startAudioEngine()
            try startRecognitionRequest()
        } catch {
            print("Error starting speech recognition: \(error)")
        }
    }
    
    func stopListening() {
        recognitionRequest?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
    }
    
    private func startAudioEngine() throws {
        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
    }
    private func startRecognitionRequest() throws {
        guard let stepsCont = stepsController else {return}
        guard stepsCont.voiceActivated else {return}
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create a recognition request.")
        }
        
        var commandRecognized = false
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            if let result = result {
                let recognizedText = result.bestTranscription.formattedString
                print("Recognized: \(recognizedText)")
                guard stepsCont.voiceActivated else {return}
                
                if recognizedText.isEmpty {
                    commandRecognized = false
                }
                
                guard !commandRecognized else {return}
                
                if recognizedText.lowercased().contains("next") && !commandRecognized {
                    print(commandRecognized)
                    commandRecognized = true
                    self.resetAudio()
                    stepsCont.performNext()
                }
                
                if recognizedText.lowercased().contains("previous") && !commandRecognized {
                    print(commandRecognized)
                    commandRecognized = true
                    self.resetAudio()
                    stepsCont.performPrevious()
                }
                
                
            }
            
            if let error = error {
                print("Recognition error: \(error)")
            }
        }
    }
    
    private func resetAudio() {
        stopListening()
        startListening()
    }
}
