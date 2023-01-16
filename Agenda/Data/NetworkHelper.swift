//
//  NetworkHelper.swift
//  Agenda
//
//  Created by Abby Dominguez on 16/1/23.
//

import Foundation

class NetworkHelper {
    
    static let shared = NetworkHelper() //<-- Make this a singleton
    
    enum RequestType: String {
        case POST
        case GET
        case DELETE
        case UPDATE
    }
    
    //MARK: - Functions
    
    func requestAPI(request: URLRequest, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
    
    func requestProvider(url: String, type: RequestType, params: [String: Any]? = nil, completion: @escaping (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Void){
        let url = URL(string: url)
        guard let url = url else {return}
        var request = URLRequest(url: url)
        request.httpMethod = type.rawValue
        
        if let dictionary = params {
            let data = try! JSONSerialization.data(withJSONObject: dictionary, options: [])
            request.httpBody = data
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestAPI(request: request) { data, response, error in completion(data, response, error)}
    }
}
