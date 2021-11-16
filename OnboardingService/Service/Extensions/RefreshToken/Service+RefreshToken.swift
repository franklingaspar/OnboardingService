//
//  Service+RefreshToken.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import OnboardingModelsTeste

public protocol OnboardingServiceRefreshTokenDelegate {
  func refreshToken(
    token: String,
    onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
  )
}

public extension Service {
    func refreshToken(
        token: String,
        onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
    ) {
        
        let parameters = [
          "refreshToken":  token,
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
