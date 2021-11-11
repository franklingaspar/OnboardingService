//
//  ServiceClient.swift
//  OnboardingService
//
//  Created by magna on 11/11/21.
//

import Foundation
import Alamofire

// MARK: Protocol
protocol OnboardingServiceClientDelegate: AnyObject {
  // default
  func request<T: Decodable>(withUrl: String, withMethod: HTTPMethod, andParameters: Parameters?,
                             onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  )

  // with headers
  func request<T: Decodable>(withUrl: String, withMethod: HTTPMethod, withHeaders: HTTPHeaders?, andParameters: Parameters?,
                              onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  )

  // with custom decoder
  func request<T: Decodable>(withUrl: String, withMethod: HTTPMethod, andParameters: Parameters?, customDecoder: JSONDecoder,
                              onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  )

  // with full response
  func requestWithFullResponse(withUrl: String, withMethod: HTTPMethod, withHeaders: HTTPHeaders?, andParameters: Parameters?,
                               onCompletion: @escaping ((AFDataResponse<Data>?) -> Void)
  )

  // without caching request
  func requestWithoutCache<T: Decodable>(withUrl: String, withMethod: HTTPMethod, andParameters: Parameters?,
                                         onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  )
    
}

// MARK: API
class OnboardingServiceClient {
  // MARK: Properties
  let httpRequest: Session

  // MARK: Init
  init() {
    let config = URLSessionConfiguration.default
    config.timeoutIntervalForRequest = 10
    httpRequest = Alamofire.Session(configuration: config)
  }

  // MARK: Actions
  func buildUrl(url urlString: String, method: HTTPMethod,
                headers: HTTPHeaders? = nil, parameters: Parameters?) throws -> URLRequestConvertible {

    let url = try urlString.asURL()
    var urlRequest = URLRequest(url: url)

    // Http method
    urlRequest.httpMethod = method.rawValue

    // Header
    if let headers = headers {
      headers.forEach { element in urlRequest.setValue(element.value, forHTTPHeaderField: element.name) }
    }

    //Encoding
    let encoding: ParameterEncoding = {
      switch method {
      case .get:
        return URLEncoding.default
      default:
        return JSONEncoding.default
      }
    }()

    return try encoding.encode(urlRequest, with: parameters)
  }
}

// MARK: Extend protocol
extension OnboardingServiceClient: OnboardingServiceClientDelegate {
  // MARK: Default
  func request<T: Decodable> (withUrl: String, withMethod: HTTPMethod = .get, andParameters: Parameters? = nil,
                              onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  ) {
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(url: withUrl, method: withMethod, parameters: withParameters)
    else {
      return onCompletion(.failure(OnboardingServiceError.cantCreateUrl))
    }

    httpRequest.request(urlRequestConvirtable).validate().responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return onCompletion(.failure(OnboardingServiceError.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return onCompletion(.success(result))
          } catch let errorCatch as NSError {
            return onCompletion(
              .failure(
                OnboardingServiceError.unknow((errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return onCompletion(
            .failure(
                OnboardingServiceError(error: error, status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: With Headers
  func request<T: Decodable> (withUrl: String, withMethod: HTTPMethod = .get, withHeaders: HTTPHeaders? = nil,
                              andParameters: Parameters? = nil,
                              onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  ) {
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(url: withUrl, method: withMethod,
                                                         headers: withHeaders,parameters: withParameters)
    else {
      return onCompletion(.failure(OnboardingServiceError.cantCreateUrl))
    }

    httpRequest.request(urlRequestConvirtable).validate().responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return onCompletion(.failure(OnboardingServiceError.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return onCompletion(.success(result))
          } catch let errorCatch as NSError {
            return onCompletion(
              .failure(
                OnboardingServiceError.unknow((errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return onCompletion(
            .failure(
                OnboardingServiceError(error: error, status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: With full response
  func requestWithFullResponse(withUrl: String, withMethod: HTTPMethod = .get,
                               withHeaders: HTTPHeaders? = nil, andParameters: Parameters? = nil,
                               onCompletion: @escaping ((AFDataResponse<Data>?) -> Void)
  ) {
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(url: withUrl, method: withMethod,
                                                         headers: withHeaders, parameters: withParameters)
    else {
      return onCompletion(nil)
    }

    httpRequest.request(urlRequestConvirtable).validate().responseData { response in
        onCompletion(response)
      }
  }

  // MARK: With Custom Decoder
  func request<T: Decodable>(withUrl: String, withMethod: HTTPMethod, andParameters: Parameters?,
                             customDecoder: JSONDecoder,
                             onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  ) {
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    guard let urlRequestConvirtable = try? self.buildUrl(url: withUrl, method: withMethod,parameters: withParameters)
    else {
      return onCompletion(.failure(OnboardingServiceError.cantCreateUrl))
    }

    
    httpRequest.request(urlRequestConvirtable).validate().responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return onCompletion(.failure(OnboardingServiceError.badRequest))
          }

          do {
            let result = try customDecoder.decode(T.self, from: data)
            return onCompletion(.success(result))
          } catch let errorCatch as NSError {
            return onCompletion(
              .failure(
                OnboardingServiceError.unknow((errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return onCompletion(
            .failure(
                OnboardingServiceError(error: error, status: response.response?.statusCode
              )
            )
          )
        }
      }
  }

  // MARK: Without cache request
  func requestWithoutCache<T: Decodable> (withUrl: String, withMethod: HTTPMethod = .get, andParameters: Parameters? = nil,
                                          onCompletion: @escaping ((Swift.Result<T, OnboardingServiceError>) -> Void)
  ) {
    var parametersDictionary: Parameters = [:]

    if let parameters = andParameters {
      parametersDictionary = parametersDictionary.merging(parameters) { _, new in new }
    }

    let withParameters: Parameters = parametersDictionary

    httpRequest.requestWithoutCache(withUrl, method: .get, parameters: withParameters,
                                    encoding: URLEncoding.default).validate().responseJSON { response in
        switch response.result {
        case .success:
          guard let data = response.data else {
            return onCompletion(.failure(OnboardingServiceError.badRequest))
          }

          do {
            let result = try JSONDecoder().decode(T.self, from: data)
            return onCompletion(.success(result))
          } catch let errorCatch as NSError {
            return onCompletion(
              .failure(
                OnboardingServiceError.unknow((errorCatch.debugDescription, nil))
              )
            )
          }

        case .failure(let error):
          return onCompletion(
            .failure(
                OnboardingServiceError(error: error, status: response.response?.statusCode
              )
            )
          )
        }
      }
  }
}

// MARK: Extend Alamofire Session Manager
extension Alamofire.Session {
  @discardableResult
  open func requestWithoutCache( _ url: URLConvertible, method: HTTPMethod = .get, parameters: Parameters? = nil,
                                 encoding: ParameterEncoding = URLEncoding.default,headers: HTTPHeaders? = nil) -> DataRequest
  {
    do {
      var urlRequest = try URLRequest(url: url, method: method, headers: headers)
      urlRequest.cachePolicy = .reloadIgnoringCacheData // <<== Cache disabled
      let encodedURLRequest = try encoding.encode(urlRequest, with: parameters)
      return request(encodedURLRequest)
    } catch {
      // TODO: find a better way to handle error
      print(error)
      return request(URLRequest(url: URL(string: "http://example.com/wrong_request")!))
    }
  }
}
