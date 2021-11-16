//
//  Service+Projects.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import Alamofire
import OnboardingModelsTeste

public protocol OnboardingServiceProjectsDelegate {
  func getProjects(
    accessToken: String,
    onCompletion completion: @escaping (Swift.Result<ProjectsResponse, OnboardingServiceError>) -> Void
  )
}

public extension Service {
    func getProjects(
        accessToken: String,
        onCompletion completion: @escaping (Swift.Result<ProjectsResponse, OnboardingServiceError>) -> Void
    ) {
        
        let headersDic: [String: String] = [
              "Access-Token": accessToken,
              "Content-Type": "application/json"
            ]
        let headers = HTTPHeaders(headersDic)

        DispatchQueue.global().async { [weak self] in
          guard let self = self else { return }

          self.service.request(
            withUrl: self.login,
            withMethod: .get,
            withHeaders: headers,
            andParameters: nil
          ) { (response: Swift.Result<ProjectsResponse, OnboardingServiceError>) in
            completion(response)
          }
        }
    }
}
