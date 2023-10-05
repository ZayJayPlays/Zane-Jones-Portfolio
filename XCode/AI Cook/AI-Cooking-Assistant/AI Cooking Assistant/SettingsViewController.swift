//
//  SettingsViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/14/23.
//

import UIKit
import Foundation

class SettingsViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard

    @IBOutlet weak var voiceControlSwitch: UISwitch!
    @IBOutlet weak var textToSpeechSwitch: UISwitch!
    @IBOutlet weak var voiceSpeedSlider: UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let isVoiceControlEnabled = userDefaults.object(forKey: "IsVoiceControlEnabled") as? Bool {
            if isVoiceControlEnabled {
                voiceControlSwitch.isOn = true
            }
            else {
                voiceControlSwitch.isOn = false
            }
        }
        if let isSpeechEnabled = userDefaults.object(forKey: "IsSpeechEnabled") as? Bool {
            if isSpeechEnabled {
                textToSpeechSwitch.isOn = true
            }
            else {
                textToSpeechSwitch.isOn = false
            }
        }
        if let speechSpeed = userDefaults.object(forKey: "SpeechSpeed") as? Float {
            voiceSpeedSlider.value = speechSpeed
        }
    }
    
    @IBAction func voiceControlSwitchChanged(_ sender: Any) {
        userDefaults.set(voiceControlSwitch.isOn, forKey: "IsVoiceControlEnabled")
    }
    
    
    @IBAction func textToSpeechSwitchChanged(sender: UISwitch) {
        userDefaults.set(textToSpeechSwitch.isOn, forKey: "IsSpeechEnabled")
    }
    
    @IBAction func speechSpeedSliderChanged(_ sender: Any) {
        userDefaults.set(voiceSpeedSlider.value, forKey: "SpeechSpeed")
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
