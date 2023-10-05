//
//  UserRecipes.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/14/23.
//

import Foundation

class UserRecipes {
    static let shared = UserRecipes()
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(UserRecipes.refreshRecipes), name: NotificationManager.didCreateCoreDataRecipe, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NotificationManager.didCreateCoreDataRecipe, object: nil)
    }
    
    @objc func refreshRecipes() {
        if let userRecipes = RecipeStorageManager.shared.retrieveAllContent() {
            allRecipes = userRecipes
        }
    }
    
    var allRecipes: [UserCreatedRecipe] = []
}
