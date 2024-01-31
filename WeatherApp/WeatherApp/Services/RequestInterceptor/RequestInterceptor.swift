//
//  RequestInterceptor.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation
import Alamofire

final class RequestInterceptor: Alamofire.RequestInterceptor  {
    
    private var apiKey: String? {
        return ProcessInfo.processInfo.environment["API_KEY"]
    }
    
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        guard let unwrappedApiKey = self.apiKey else {
            completion(.failure(ServerError(code: 1002, message: "API key not provided")))
            return
        }
        
        var urlRequest = urlRequest
        
        let params = ["key": unwrappedApiKey]
        
        if let encodedURLRequest = try? URLEncodedFormParameterEncoder.default.encode(params, into: urlRequest) {
            completion(.success(encodedURLRequest))
        } else {
            completion(.failure(ServerError(code: 1002, message: "Failed to encode parameters")))
        }
    }
}


