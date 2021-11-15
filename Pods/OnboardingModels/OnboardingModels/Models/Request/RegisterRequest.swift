//
//  RegisterRequest.swift
//  OnboardingModels
//
//  Created by magna on 15/11/21.
//

import Foundation

public class RegisterRequest: Codable {
    public var name: String
    public var surname: String
    public var cpf: String
    public var rg: String
    public var email: String
    public var password: String
    
    init(name: String, surname: String, cpf: String, rg: String, email: String, password: String) {
        self.name = name
        self.surname = surname
        self.cpf = cpf
        self.rg = rg
        self.email = email
        self.password = password
    }
}
