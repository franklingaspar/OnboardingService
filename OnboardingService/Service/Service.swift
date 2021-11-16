//
//  Service.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation

public class Service {
  // MARK: Properties
    let service: OnboardingServiceClientDelegate


    let login = Constants.login.rawValue
    let register = Constants.register.rawValue
    let refreshToken = Constants.refreshToken.rawValue
    let projects = Constants.projects.rawValue


   public init() {
        self.service = OnboardingServiceClient()
    }

}

extension Service: OnboardingDelegate {}
