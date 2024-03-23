//
//  HttpUtilities.swift
//  JetDevsHomeWork
//
//  Created by APPLE on 23/03/24.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
}

enum NetworkApi: String {
    case login 
}

class HTTPUtility {
    static let shared = HTTPUtility()
    
    private init() {}
    
    func requestData(from url: NetworkApi, method: HTTPMethod, parameters: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
        
        let urlString = "https://jetdevs.wiremockapi.cloud/" + url.rawValue
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if method == .POST {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(error))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(NSError(domain: "Invalid response", code: 0, userInfo: nil)))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(NSError(domain: "HTTP Error", code: httpResponse.statusCode, userInfo: nil)))
                return
            }
            
            guard let responseData = data else {
                completion(.failure(NSError(domain: "No data", code: 0, userInfo: nil)))
                return
            }
            
            completion(.success(responseData))
        }
        
        task.resume()
    }
}
