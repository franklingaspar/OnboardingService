////
////  Service+Register.swift
////  OnboardingService
////
////  Created by magna on 11/11/21.
////
//
//import Foundation
//import OnboardingModels
//
//public protocol OnboardingServiceRegisterDelegate {
//  func register(
//    register: RegisterRequest,
//    onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
//  )
//}
//
//public extension Service {
//    func register(
//        register: RegisterRequest,
//        onCompletion completion: @escaping (Swift.Result<TokenResponse, OnboardingServiceError>) -> Void
//    ) {
//    
//        let parameters = [
//            "name":  register.name,
//            "surname": register.surname,
//            "cpf": register.cpf,
//            "rg": register.rg,
//            "email": register.email,
//            "password": register.password
//        ]
//
//        DispatchQueue.global().async { [weak self] in
//          guard let self = self else { return }
//
//          self.service.request(
//            withUrl: self.login,
//            withMethod: .post,
//            andParameters: parameters
//          ) { (response: Swift.Result<TokenResponse, OnboardingServiceError>) in
//            completion(response)
//          }
//        }
//    }
//}
