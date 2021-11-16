//
//  Service+Login.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import OnboardingModelsTeste

public protocol OnboardingServiceLoginDelegate {
  func login(
    email: String,
    password: String,
    onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
  )
}

public extension Service {
    func login(
        email: String,
        password: String,
        onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
    ) {
        
        let parameters = [
          "email":  email,
          "password": password
        ]

        DispatchQueue.global().async { [weak self] in
          guard let self = self else { return }

          self.service.request(
            withUrl: Constants.baseUrl.rawValue + self.login,
            withMethod: .post,
            andParameters: parameters
          ) { (response: Swift.Result<TokenResponse, OnboardingServiceError>) in
            completion(response)
          }
        }
    }
}
