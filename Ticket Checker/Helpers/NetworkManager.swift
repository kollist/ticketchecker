//
//  NetworkManager.swift
//  Ticket Checker
//
//  Created by Zaytech Mac on 6/11/2024.


import Foundation
import Alamofire

struct ErrorResponse: Codable, Error {
    let error: String
}



class NetworkManager {
    
    static let shared = NetworkManager()
    
    // Generalized request function for both GET and POST request
    func request(
        sooApi: SOOApi,
        completion: @escaping (Result<Data, ErrorResponse>) -> Void
    ) {
        AF.request(sooApi.url, method: sooApi.method, parameters: sooApi.parameters, encoding: sooApi.parameterEncoding, headers: sooApi.headers)
            .validate()
            .responseData { response in
                dump(response)
                switch response.result {
                    case .success(let data):
                        completion(.success(data))
                    case .failure(let error):
                        if let data = response.data, let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) {
                            completion(.failure(errorResponse))
                        } else {
                            let error = ErrorResponse(error: error.localizedDescription)
                            completion(.failure(error))
                        }
                }
            }
    }
}

