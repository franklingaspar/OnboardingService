//
//  Connectivity.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import Alamofire

public class Connectivity {
  public class func isConnectedToInternet() -> Bool {
    return NetworkReachabilityManager()?.isReachable ?? false
  }
}
