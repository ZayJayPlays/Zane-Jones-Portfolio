//
//  OpenAIService.swift
//  AI Cooking Assistant
//
//  Created by Juliana Nielson on 9/7/23.
//

import Foundation
import Alamofire
import UIKit
import SwiftUI

class OpenAIService {
    private let endpointURL = "https://api.openai.com/v1"
    
    enum WhichEndpoint: String {
        case completions = "/chat/completions"
        case dalle = "/images/generations"
    }
    
    enum HTTPMethod: String {
        case post = "POST"
        case get = "GET"
    }
    
    //Initialize reusable decoder and session
    let decoder = JSONDecoder()
    let encoder = JSONEncoder()
    var session = URLSession.shared
    static let shared = OpenAIService()
    
    enum APIError: String, Error, LocalizedError {
        case invalidResponse
        case wasNot200
        case imageDataMissing
    }
    
    func sendMessage(messages: [Message]) async -> OpenAIChatResponse? {
        let openAIMessages = messages.map({OpenAIChatMessage(role: $0.role, content: $0.content)})
        let body = OpenAIChatBody(model: OpenAIModel.GPT35, messages: openAIMessages, stream: false)
        let headers: HTTPHeaders = ["Authorization": "Bearer \(Constants.openAIAPIKey)"]
        return try? await AF.request(endpointURL + WhichEndpoint.completions.rawValue, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAIChatResponse.self).value
    }
    
    func fetchImage(from url: URL) async throws -> UIImage {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
           httpResponse.statusCode == 200 else {
            throw APIError.wasNot200
        }
        
        guard let image = UIImage(data: data) else {
            throw APIError.imageDataMissing
        }
        
        return image
    }
    
    func sendDallERequest(using prompt: String, size: ImageSize) async throws -> DallEImage {
        var request = URLRequest(url: URL(string: endpointURL + WhichEndpoint.dalle.rawValue)!)
        request.httpMethod = HTTPMethod.post.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.headers = ["Authorization": "Bearer \(Constants.openAIAPIKey)"]

        let parameters: [String: Any] = [
            "prompt": prompt,
            "size": size.rawValue
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)

        request.httpBody = jsonData

        let (data, response) = try await session.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }

        guard httpResponse.statusCode == 200 else {
            print(httpResponse)
            throw APIError.wasNot200
        }

        let decoded = try decoder.decode(DallEResponse.self, from: data)

        return decoded.data[0]
    }
}
