//
//  FormViewController.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/12/23.
//

import UIKit

class FormViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var promptTextField: CustomTextView!
    @IBOutlet weak var cookButton: UIButton!
    
    var promptedStrings = String()
    var numberOfPeople = String()
    var badIngredients = String()

    var internetCheck = InternetCheck()
    var isConnected = Bool()
    var onView = Bool()
    
    var font: UIFont?
    var fontSize: CGFloat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        promptTextField.delegate = self
        cookButton.isEnabled = false
        promptTextField.delegate = self
        promptTextField.text = "I want to cook..."
        promptTextField.textColor = promptTextField.customGray
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        promptedStrings.append(promptTextField.text!)
        promptedStrings.append(numberOfPeople.isEmpty ? "":" for \(numberOfPeople)")
        promptedStrings.append(badIngredients.isEmpty ? "":" but I can't use \(badIngredients)")
        onView = true
        checkInternetConnection()
    }
    
    func checkInternetConnection() {
        isConnected = internetCheck.isInternetAvailable()
        updateUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.onView {
                self.checkInternetConnection()
            }
        }
    }
    
    //For testing ease; taps Cook immediately after load
//    override func viewDidAppear(_ animated: Bool) {
//        cookButton.sendActions(for: .touchUpInside)
//    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        promptTextField.resignFirstResponder()
        return true
    }
    
    
    func updateUI() {
        
        guard isConnected else {
            cookButton.setTitle("No Connection", for: .normal)
            cookButton.titleLabel?.adjustsFontSizeToFitWidth = true
            cookButton.isEnabled = false
            return
        }
        
        let alphabet = NSCharacterSet.letters
        cookButton.titleLabel?.text = "Cook!"
        cookButton.titleLabel?.adjustsFontSizeToFitWidth = false
        cookButton.titleLabel?.textAlignment = .center
        let defaultFontSize: CGFloat = 25.0
        cookButton.titleLabel?.font = UIFont.systemFont(ofSize: defaultFontSize)
        if let prompt = promptTextField.text, prompt.rangeOfCharacter(from: alphabet) != nil {
            cookButton.isEnabled = true
        } else {
            cookButton.isEnabled = false
        }
    }
    
    let testObject1 = "Recipe Title: Gourmet Mushroom Swiss Burgers \nIngredients: \n- 1 lb ground beef \n- 4 burger buns \n- 4 slices of Swiss cheese \n- 1 cup sliced mushrooms (button or cremini) \n- 1 small onion, thinly sliced \n- 2 cloves garlic, minced \n- 2 tablespoons olive oil \n- Salt and pepper, to taste \n- Optional toppings: lettuce, tomato, caramelized onions, ketchup, mustard"
    let testObject2 = "1. In a large skillet, heat 1 tablespoon of olive oil over medium heat. \n2. Add the sliced onions and cook until they are caramelized, stirring occasionally. This should take about 10 minutes. \n3. In the same skillet, add the sliced mushrooms and minced garlic. Cook for another 5 minutes until the mushrooms are softened. \n4. Remove the onion and mushroom mixture from the skillet and set aside. \n5. Preheat your grill or stovetop grill pan to medium-high heat. \n6. Divide the ground beef into 4 equal portions and shape them into burger patties. \n7. Season the patties with salt and pepper on both sides. \n8. Brush the grill grates with olive oil to prevent sticking. \n9. Place the burger patties on the grill and cook for about 4-5 minutes per side for medium doneness. \n10. During the last minute of cooking, place a slice of Swiss cheese on each patty to allow it to melt. \n11. Remove the burger patties from the grill and let them rest for a few minutes. \n12. Toast the burger buns on the grill or in a toaster until lightly golden. \n13. Assemble the burgers by placing a patty on the bottom bun. \n14. Top with the onion and mushroom mixture. \n15. Add any optional toppings such as lettuce, tomato, caramelized onions, ketchup, or mustard. \n16. Place the top bun on the burger and serve immediately. \n17. Enjoy your delicious gourmet mushroom Swiss burgers!"
    
    @IBAction func cookButtonTapped(_ sender: Any) {
        realNetworkCall()
    }
    
    func realNetworkCall() {
        let shared = ResponseObject.shared
        
        promptedStrings.append(promptTextField.text!)
        promptedStrings.append(numberOfPeople.isEmpty ? "":"for \(numberOfPeople)")
        promptedStrings.append(badIngredients.isEmpty ? "":"but I can't use\(badIngredients)")
        
        Task {
            shared.response.removeAll()
            var recipe = UserCreatedRecipe(id: UUID(), ingredientsList: "", steps: "")
            
            // First call to generate just the recipe title
            let titleResponse = await OpenAIService.shared.sendMessage(messages: [
                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
                Message(id: UUID().uuidString, role: .user, content: "Generate a recipe title based on this request: \(promptedStrings)")
            ])
            
            if let title = titleResponse?.choices[0].message.content {
                recipe.title = title.replacingOccurrences(of: "\"", with: "")
            }
            
            // Second call to generate the ingredients
            if let theTitle = recipe.title {
                let ingredientsResponse = await OpenAIService.shared.sendMessage(messages: [
                    Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
                    Message(id: UUID().uuidString, role: .user, content: "Generate a list of ingredients based on this recipe title: \(theTitle)")
                ])
                
                if let ingredients = ingredientsResponse?.choices[0].message.content {
                    recipe.ingredientsList = theTitle + "\n\n" + ingredients
                    shared.response.append(recipe.ingredientsList)
                }
            }
            
            // Third call to generate the steps
            let stepsResponse = await OpenAIService.shared.sendMessage(messages: [
                Message(id: UUID().uuidString, role: .system, content: "You are a seasoned chef, with years of experience in the culinary world, renowned for your skill in both traditional and innovative cooking techniques. You are guiding users through an interactive cooking experience."),
                Message(id: UUID().uuidString, role: .user, content: "Generate steps for how to prepare this recipe in the format 1. 2. 3. etc. based on this list of ingredients: \(recipe.ingredientsList)")
            ])
            
            if let steps = stepsResponse?.choices[0].message.content {
                ResponseObject.convertStepsToList(input: steps, modify: &shared.response)
                recipe.steps = steps
            }
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)

            // Save to Core Data
            RecipeStorageManager.shared.createCoreDataRecipe(for: recipe)
        }

    }
    
    func fakeNetworkCall() {
        let shared = ResponseObject.shared
        shared.response.removeAll()
        shared.response.append(testObject1)
        ResponseObject.convertStepsToList(input: testObject2, modify: &shared.response)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
        }
        
        RecipeStorageManager.shared.createCoreDataRecipe(for: UserCreatedRecipe(id: UUID(), title: "test", ingredientsList: testObject1, steps: testObject2))
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCustomize" {
            let destination = segue.destination as! CustomizeViewController
            destination.formView = self
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        onView = false
    }
    
    
    func textViewDidChangeSelection(_ textView: UITextView) {
        if self.view.window != nil {
            if textView.textColor == promptTextField.customGray {
                textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText: String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = "I want to cook..."
            textView.textColor = promptTextField.customGray
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.textColor == promptTextField.customGray && !text.isEmpty {
            textView.textColor = UIColor.black
            textView.text = text
        } else {
            return true
        }
        return false
    }
}
