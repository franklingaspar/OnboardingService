//
//  Service+Register.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import OnboardingModelsTeste

public protocol OnboardingServiceRegisterDelegate {
  func register(
    register: RegisterRequest,
    onCompletion completion: @escaping (Swift.Result<String?, OnboardingServiceError>) -> Void
  )
}

public extension Service {
    func register(
        register: RegisterRequest,
        onCompletion completion: @escaping (Swift.Result<String?, OnboardingServiceError>) -> Void
    ) {
    
        let parameters = [
            "name":  register.name,
            "surname": register.surname,
            "cpf": register.cpf,
            "rg": register.rg,
            "email": register.email,
            "password": register.password
        ]

        DispatchQueue.global().async { [weak self] in
          guard let self = self else { return }

          self.service.request(
            withUrl: Constants.baseUrl.rawValue + self.register,
            withMethod: .post,
            andParameters: parameters
          ) { (response: Swift.Result<String?, OnboardingServiceError>) in
            completion(response)
          }
        }
    }
}
