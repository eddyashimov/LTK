//
//  Network.swift
//  LTK Challenge
//
//  Created by Edil Ashimov on 2/8/22.
//

import Foundation

class Network {
    
    static var shared: Network = {
        return Network()
    }()
    
    private func httpHeaderFields() -> [String: String] {
        return ["Content-Type": "application/json"]
    }
    
    private func request(url: String,
                         httpMethod: String,
                         httpHeaderFields: [String:String],
                         httpBody: Data?,
                         parameters: [URLQueryItem]?,
                         handler: @escaping (Data?, URLResponse?, Int?, Error?) -> Void) {
        
        guard let _url = URL(string: url) else { return }
        
        var request: URLRequest = URLRequest(withUrl: _url,
                                             httpBody: nil,
                                             httpHeaderFields: httpHeaderFields,
                                             httpMethod: URLRequest.httpMethod.GET)
        request.cachePolicy = .returnCacheDataElseLoad
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            let httpResponsStatusCode = (response as? HTTPURLResponse)?.statusCode
            handler(data, response, httpResponsStatusCode, error)
            
        }.resume()
    }
    
}

extension Network {
    
    func getFeed(completion: @escaping(JSON.Item?, Error?) -> Void) {
        
        request(url: EndPoints.Ltks.path,
                httpMethod: URLRequest.httpMethod.GET,
                httpHeaderFields: httpHeaderFields(),
                httpBody: nil,
                parameters: nil) { data, response, status, error in
            
            guard let _data = data, status == 200 else { return }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(JSON.Item.self, from: _data)
                completion(result, nil)
            }
            catch let error {
                completion(nil, error)
            }
        }
    }
    
    func loadProfileImage(with id: String, handler: @escaping(JSON.Profile?, Error?) -> Void) {
        
        request(url: EndPoints.Profiles.path + id,
                httpMethod: URLRequest.httpMethod.GET,
                httpHeaderFields: httpHeaderFields(),
                httpBody: nil, parameters: nil) { data, response, status, error in
            
            guard let _data = data, status == 200 else { return }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(JSON.Profile.self, from: _data)
                handler(result, nil)
            }
            catch let error {
                handler(nil, error)
            }
        }
    }
    
    func loadProductImage(with id: String, handler: @escaping(JSON.Products?, Error?) -> Void) {
        
        request(url: EndPoints.Products.path + id,
                httpMethod: URLRequest.httpMethod.GET,
                httpHeaderFields: httpHeaderFields(),
                httpBody: nil, parameters: nil) { data, response, status, error in
            
            guard let _data = data, status == 200 else { return }
            do {
                let decoder = JSONDecoder()
                let result = try decoder.decode(JSON.Products.self, from: _data)
                handler(result, nil)
            }
            catch let error {
                handler(nil, error)
            }
        }
    }
    
    func getImage(with path: String, handler: @escaping(Data?, Error?) -> Void) {
        guard let url = URL(string: path) else { return }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        request.httpMethod = URLRequest.httpMethod.GET
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _data = data {
                handler(_data, nil)
            }
            else {
                handler(nil, error)
            }
            
        }.resume()
    }
    
}

