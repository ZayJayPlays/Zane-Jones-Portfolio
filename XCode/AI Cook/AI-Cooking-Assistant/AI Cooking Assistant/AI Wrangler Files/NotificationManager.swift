//
//  NotificationManager.swift
//  AI Cooking Assistant
//
//  Created by David Granger on 9/7/23.
//

import Foundation

public struct NotificationManager {
    static let didReceiveNetworkResponse = Notification.Name("didReceiveNetworkResponse")
    static let didCreateCoreDataRecipe = Notification.Name("didCreateCoreDataRecipe")
    static let didRemoveCoreDataRecipe = Notification.Name("didRemoveCoreDataRecipe")
}
