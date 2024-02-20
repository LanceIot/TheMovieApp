//
//  SessionIDResponse.swift
//  MoviesMVVM
//
//  Created by Админ on 22.01.2024.
//

import Foundation

struct SessionIDResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String?
    let sessionId: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
        case sessionId = "session_id"
    }
}
