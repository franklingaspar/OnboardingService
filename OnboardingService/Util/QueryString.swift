//
//  QueryString.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation

public func QueryString(_ value: String, params: [String: String]) -> String? {
  var components = URLComponents(string: value)
  components?.queryItems = params.map { element in URLQueryItem(name: element.key, value: element.value) }

  return components?.url?.absoluteString
}
