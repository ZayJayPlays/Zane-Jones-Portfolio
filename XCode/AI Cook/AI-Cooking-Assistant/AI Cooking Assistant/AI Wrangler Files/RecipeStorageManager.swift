//
//  RecipeStorageManager.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/11/23.
//

import Foundation
import CoreData

class RecipeStorageManager {
    static let shared = RecipeStorageManager()
    
    private let persistenceController = PersistenceController.shared
    private let context = PersistenceController.shared.viewContext
    
    //MARK: Recipe retrieval
    func retrieveAllContent() -> [UserCreatedRecipe]? {
        do {
            var returnArray: [UserCreatedRecipe] = []
            let results = try context.fetch(Recipe.fetchRequest())
            for recipeItem in results {
                guard let uuid = recipeItem.id,
                      let ingredients = recipeItem.ingredientsList,
                      let steps = recipeItem.steps else { continue }
                
                // Title can be nil
                let title = recipeItem.title
                
                let createdObject = UserCreatedRecipe(id: uuid, title: title, ingredientsList: ingredients, steps: steps)
                returnArray.append(createdObject)
            }
            return returnArray
        } catch {
            print("Failed to fetch recipe items from CoreData: \(error)")
            return nil
        }
    }
    
    func retrieveRecipe(byTitle lookupTitle: String) -> UserCreatedRecipe? {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", lookupTitle)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            // Assuming titles are unique, only one match should be found.
            // If titles are not unique, this will return the first matching recipe.
            if let firstMatch = results.first {
                guard let uuid = firstMatch.id,
                      let ingredients = firstMatch.ingredientsList,
                      let steps = firstMatch.steps else {
                    return nil
                }
                
                //Title can be nil
                let title = firstMatch.title
                
                let recipe = UserCreatedRecipe(id: uuid, title: title, ingredientsList: ingredients, steps: steps)
                return recipe
            } else {
                return nil  // Nil is returned when no match found
            }
        } catch {
            print("Failed to fetch recipe by title from CoreData: \(error)")
            return nil
        }
    }
    
    func retrieveRecipe(byUUID lookupUUID: UUID) -> UserCreatedRecipe? {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", lookupUUID as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let firstMatch = results.first {
                guard let uuid = firstMatch.id,
                      let ingredients = firstMatch.ingredientsList,
                      let steps = firstMatch.steps else {
                    return nil
                }
                
                // Title can be nil
                let title = firstMatch.title
                
                let recipe = UserCreatedRecipe(id: uuid, title: title, ingredientsList: ingredients, steps: steps)
                return recipe
            } else {
                return nil  // Nil is returned when no match found
            }
        } catch {
            print("Failed to fetch recipe by UUID from CoreData: \(error)")
            return nil
        }
    }
    
    //MARK: Recipe removal
    func removeRecipe(matching title: String) {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@", title)
        
        do {
            let results = try context.fetch(fetchRequest)
            
            // Assuming titles are unique, only one match should be found.
            // If titles are not unique, this will remove the first matching recipe.
            if let recipeToRemove = results.first {
                context.delete(recipeToRemove)
                persistenceController.saveContext()
            } else {
                print("No recipe found with the title \(title)")
            }
        } catch {
            print("Failed to remove recipe: \(error)")
        }
        NotificationCenter.default.post(name: NotificationManager.didRemoveCoreDataRecipe, object: nil)
    }
    
    func removeRecipe(matching uuid: UUID) {
        let fetchRequest: NSFetchRequest<Recipe> = Recipe.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
        
        do {
            let results = try context.fetch(fetchRequest)
            if let recipeToRemove = results.first {
                context.delete(recipeToRemove)
                persistenceController.saveContext()
            } else {
                print("No recipe found with the uuid \(uuid)")
            }
        } catch {
            print("Failed to remove recipe: \(error)")
        }
        NotificationCenter.default.post(name: NotificationManager.didRemoveCoreDataRecipe, object: nil)
    }
    
    //MARK: Recipe creation
    func createCoreDataRecipe(for recipe: UserCreatedRecipe) {
        let coreDataRecipe = Recipe(context: context)
        coreDataRecipe.id = recipe.id
        coreDataRecipe.title = recipe.title
        coreDataRecipe.ingredientsList = recipe.ingredientsList
        coreDataRecipe.steps = recipe.steps
        persistenceController.saveContext()
        NotificationCenter.default.post(name: NotificationManager.didCreateCoreDataRecipe, object: nil)
    }
}
