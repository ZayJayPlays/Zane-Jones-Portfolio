//
//  ResponseObject.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/7/23.
//

import Foundation

class ResponseObject {
    static let shared = ResponseObject()
    
    var response: [String] = []
    
    static func convertStepsToList(input: String, modify existingArray: inout [String]) {
        // Split the string by the newline character to get each line
        let lines = input.split(separator: "\n")
        
        // Initialize an empty string to hold the current step
        var currentStep: String = ""
        
        // Loop through each line
        for line in lines {
            // Use regex to find if the line starts with step numbering (e.g., "1.", "2.", etc.)
            let regex = try! NSRegularExpression(pattern: "^\\d+\\.")
            
            let range = NSRange(location: 0, length: line.utf16.count)
            
            if regex.firstMatch(in: String(line), options: [], range: range) != nil {
                // Save the current step if it's not empty
                if !currentStep.isEmpty {
                    existingArray.append(currentStep)
                }
                
                // Start a new step
                currentStep = String(line)
            } else {
                // Append the line to the current step
                currentStep += "\n" + line
            }
        }
        
        // Add the last step if it's not empty
        if !currentStep.isEmpty {
            existingArray.append(currentStep)
        }
    }
}
