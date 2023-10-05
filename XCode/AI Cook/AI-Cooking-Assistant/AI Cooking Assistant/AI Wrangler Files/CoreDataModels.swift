//
//  CoreDataModels.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/11/23.
//

import Foundation

struct UserCreatedRecipe { //purpose of this struct is to act as an interface object between our app and the core data store
    var id: UUID
    var title: String?
    var ingredientsList: String
    var steps: String
}
