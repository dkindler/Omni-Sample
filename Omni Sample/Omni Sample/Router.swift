//
//  Router.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/22/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    // User
    case login()

    // Item
    case getItems()
    
    static let baseURLString = "https://omniprojects.github.io/omni-ios-sample/api/"

    var method: HTTPMethod {
        switch self {
            
        //User
        case .login:
            return .get
            
        // Item
        case .getItems:
            return .get
        }
    }
    
    var path: String {
        switch self {
        // User
        case .login:
            return "login.json"
            
        // Item
        case .getItems:
            return "items.json"
        }
    }
    
    // MARK: URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        urlRequest = try URLEncoding.default.encode(urlRequest, with: nil)
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        return urlRequest
    }
}
