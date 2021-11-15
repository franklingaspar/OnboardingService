//
//  TokenResponse.swift
//  OnboardingModelsTeste
//
//  Created by magna on 15/11/21.
//

import Foundation

public class TokenResponse: Codable {
    public var token: String
    public var refreshToken: String
    
    init(token: String, refreshToken: String) {
        self.token = token
        self.refreshToken = refreshToken
    }
}
