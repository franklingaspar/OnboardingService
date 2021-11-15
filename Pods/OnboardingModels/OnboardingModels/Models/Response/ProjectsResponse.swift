//
//  ProjectsResponse.swift
//  OnboardingModels
//
//  Created by magna on 15/11/21.
//

import Foundation

public class ProjectsResponse: Codable {
    public var projects: [Project]
    
    init(projects: [Project]) {
        self.projects = projects
    }
}
