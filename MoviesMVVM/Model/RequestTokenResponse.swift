//
//  RequestTokenResponse.swift
//  MoviesMVVM
//
//  Created by Админ on 22.01.2024.
//

import Foundation

struct RequestTokenResponse: Codable {
    let success: Bool
    let expiresAt: String?
    let requestToken: String

    enum CodingKeys: String, CodingKey {
        case success
        case expiresAt = "expires_at"
        case requestToken = "request_token"
    }
}
