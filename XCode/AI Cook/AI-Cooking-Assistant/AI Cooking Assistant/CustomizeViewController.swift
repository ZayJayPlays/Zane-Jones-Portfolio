//
//  CustomizeViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/18/23.
//

import UIKit

class CustomizeViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var numberOfPeopleTextField: CustomTextView!
    @IBOutlet weak var badIngredientsTextField: CustomTextView!
    @IBOutlet weak var keepChangesSwitch: UISwitch!
    
    let userDefaults = UserDefaults.standard
    var keepChanges: Bool = Bool()
    
    var formView: FormViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numberOfPeopleTextField.keyboardType = .numberPad

        numberOfPeopleTextField.delegate = self
        badIngredientsTextField.delegate = self
        
        keepChanges = userDefaults.bool(forKey: "KeepChanges")
        keepChangesSwitch.isOn = keepChanges
        
        if keepChanges {
            if let numberOfPeople = userDefaults.string(forKey: "NumberOfPeople"), !numberOfPeople.isEmpty {
                numberOfPeopleTextField.text = numberOfPeople
                numberOfPeopleTextField.textColor = UIColor.black
            } else {
                numberOfPeopleTextField.text = ""
                numberOfPeopleTextField.textColor = numberOfPeopleTextField.customGray
            }
            
            if let badIngredients = userDefaults.string(forKey: "BadIngredients"), !badIngredients.isEmpty {
                badIngredientsTextField.text = badIngredients
                badIngredientsTextField.textColor = UIColor.black
            } else {
                badIngredientsTextField.text = ""
                badIngredientsTextField.textColor = badIngredientsTextField.customGray
            }
        } else {
            numberOfPeopleTextField.text = String(describing: formView!.numberOfPeople)
            numberOfPeopleTextField.textColor = UIColor.black
            badIngredientsTextField.text = String(describing: formView!.badIngredients)
            badIngredientsTextField.textColor = UIColor.black
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        formView?.numberOfPeople = numberOfPeopleTextField.text!
        formView?.badIngredients = badIngredientsTextField.text!
        
        keepChanges = keepChangesSwitch.isOn
        userDefaults.setValue(keepChanges, forKey: "KeepChanges")
        
        if keepChanges {
            userDefaults.setValue(numberOfPeopleTextField.text, forKey: "NumberOfPeople")
            userDefaults.setValue(badIngredientsTextField.text, forKey: "BadIngredients")
        } else {
            userDefaults.setValue("", forKey: "NumberOfPeople")
            userDefaults.setValue("", forKey: "BadIngredients")
        }
        
    }

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == numberOfPeopleTextField.customGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
            if textView.textColor == badIngredientsTextField.customGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        
        if updatedText.isEmpty {
            textView.text = ""
            textView.textColor = textView == numberOfPeopleTextField ? numberOfPeopleTextField.customGray : badIngredientsTextField.customGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else {
            if textView.textColor == (textView == numberOfPeopleTextField ? numberOfPeopleTextField.customGray : badIngredientsTextField.customGray) && !text.isEmpty {
                textView.textColor = UIColor.black
            }
            return true
        }
        
        return false
    }

}
