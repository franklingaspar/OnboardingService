//
//  LoginRequest.swift
//  OnboardingModels
//
//  Created by magna on 15/11/21.
//

import Foundation

public class LoginRequest: Codable {
    public var email: String
    public var password: String
    
    init(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
