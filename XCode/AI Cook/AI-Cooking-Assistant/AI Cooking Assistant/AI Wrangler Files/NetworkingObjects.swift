//
//  NetworkingObjects.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/7/23.
//

import Foundation

struct DallEResponse: Codable {
    let created: Int
    let data: [DallEImage]
}

struct DallEImage: Codable {
    let url: String
}

enum OpenAIModel: String, Codable, CaseIterable {
    case GPT35 = "gpt-3.5-turbo-16k"
    case GPT4 = "gpt-4"
}

struct OpenAIChatBody: Codable {
    let model: OpenAIModel
    let messages: [OpenAIChatMessage]
    let stream: Bool
}

struct OpenAIChatMessage: Codable {
    let role: SenderRole
    let content: String
}

struct OpenAIChatResponse: Codable {
    let id: String
    let object: String
    let created: Int
    let model: String
    let choices: [OpenAIChatChoice]
    let usage: Usage
}

struct Usage: Codable {
    let prompt_tokens: Int
    let completion_tokens: Int
    let total_tokens: Int
}

struct OpenAIChatChoice: Codable {
    let message: OpenAIChatMessage
}

struct Message: Codable, Identifiable, Equatable, Hashable {
    var id: String
    var role: SenderRole
    var content: String
    //var createdAt: Date
}

enum SenderRole: String, Codable { //Which role the message has
    case system //Any primer
    case user //User prompt
    case assistant //Response
}

enum ImageSize: String {
    case s256 = "256x256"
    case s512 = "512x512"
    case s1024 = "1024x1024"
}
