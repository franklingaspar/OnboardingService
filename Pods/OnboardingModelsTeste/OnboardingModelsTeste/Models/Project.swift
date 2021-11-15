//
//  Project.swift
//  OnboardingModelsTeste
//
//  Created by magna on 15/11/21.
//

import Foundation

public class Project: Codable {
    public var id : Int
    public var url: String
    
    init(id: Int, url: String) {
        self.id = id
        self.url = url
    }
}
