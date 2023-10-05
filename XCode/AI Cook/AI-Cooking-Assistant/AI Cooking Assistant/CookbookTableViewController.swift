//
//  CookbookTableViewController.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/14/23.
//

import UIKit

class CookbookTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UserRecipes.shared.refreshRecipes()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return UserRecipes.shared.allRecipes.count
    }
    
    @IBSegueAction func presentSteps(_ coder: NSCoder, sender: Any?) -> StepsViewController? {
        guard let cell = sender as? UITableViewCell,
              let indexPath = tableView.indexPath(for: cell) else {
            return StepsViewController(coder: coder)
        }
        
        ResponseObject.shared.response.removeAll()
        ResponseObject.shared.response.append(UserRecipes.shared.allRecipes[indexPath.row].ingredientsList)
        ResponseObject.convertStepsToList(input: UserRecipes.shared.allRecipes[indexPath.row].steps, modify: &ResponseObject.shared.response)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            NotificationCenter.default.post(name: NotificationManager.didReceiveNetworkResponse, object: nil)
        }
        
        let stepsVC = StepsViewController(coder: coder)
        
        return stepsVC
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "defaultCell", for: indexPath)
        
        var content = cell.defaultContentConfiguration()
        content.text = UserRecipes.shared.allRecipes[indexPath.row].title
        
        cell.contentConfiguration = content
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
     }
     */
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let recipeTitle = UserRecipes.shared.allRecipes[indexPath.row].title {
                RecipeStorageManager.shared.removeRecipe(matching: recipeTitle)
            }
            UserRecipes.shared.allRecipes.remove(at: indexPath.row)
            UserRecipes.shared.refreshRecipes()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
