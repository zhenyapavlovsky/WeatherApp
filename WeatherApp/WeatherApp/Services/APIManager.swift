//
//  APIManager.swift
//  WeatherApp
//
//  Created by Roman Sorochak on 26.10.2023.
//

import Foundation
import Alamofire

protocol APIManager {
    
    func request(
        with url: URL,
        method: HTTPMethod,
        parameters: Parameters?,
        headers: HTTPHeaders?,
        completion: @escaping (Result<Data?, Error>) -> Void
    )
}

class APIManagerImpl: APIManager {
    
    static let sharedInstance = APIManagerImpl()

    private let session: Session

    private init() {
        let configuration = URLSessionConfiguration.default
        let interceptor = RequestInterceptor()
        session = Session(configuration: configuration, interceptor: interceptor)
    }

    func request(
        with url: URL,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completion: @escaping (Result<Data?, Error>) -> Void
    ) {
        session.request(url, method: method, parameters: parameters, encoding: URLEncoding.default, headers: headers)
            .response { response in
                if let statusCode = response.response?.statusCode, !(200...299).contains(statusCode), let data = response.data {
                    do {
                        let serverError = try JSONDecoder().decode(ServerError.self, from: data)
                        completion(.failure(serverError))
                    } catch {
                        completion(.failure(ServerError(code: statusCode, message: "Failed to parse server error")))
                    }
                } else {
                    switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure:
                        completion(.failure(UnexpectedError()))
                    }
                }
            }
    }
}
