//
//  OmniWebManager.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import Alamofire

class OmniWebManager: NSObject {
    static let shared = OmniWebManager()
    private let savedUserKey = "currentUserKey"
    private var currentUser: User? {
        didSet {
            if let user = self.currentUser {
                let encodedData = NSKeyedArchiver.archivedData(withRootObject: user)
                UserDefaults.standard.set(encodedData, forKey: savedUserKey)
            } else {
                UserDefaults.standard.set(nil, forKey: savedUserKey)
            }
        }
    }
    
    override init() {
        super.init()
        if let data = UserDefaults.standard.data(forKey: savedUserKey), let user = NSKeyedUnarchiver.unarchiveObject(with: data) as? User {
            self.currentUser = user
        }
    }
    
    // MARK: - Current User
    
    /**
     Returns the current user if logged in
     */
    func getCurrentUser() -> User? {
        return currentUser
    }
    
    //MARK: - Items
    
    /**
     Simulates a network call to the server fetching Items.
     - parameter completion: Handler for async calls
     */
    func getItems(completion: (([Item]?, Error?) -> ())?) {
        
        request(url: Router.getItems()) { (jsonData, error) in
            if let jsonData = jsonData, let jsonItems = jsonData["content"] as? [[String: Any]] {
                var items = [Item]()
                for item in jsonItems {
                    items.append(Item(dict: item))
                }
                
                completion?(items, error)
            }
        }
    }
    
    //MARK: - Login / Logout
    
    /**
     Logs the current user out.
     */
    func logout() {
        currentUser = nil
    }
    
    /**
     Simulates a network call to the server for logging a user in.
     - parameter email: Users email address.
     - parameter password: Users password.
     - parameter completion: Handler for async calls
     */
    func login(email: String, password: String, completion: ((User?, Error?) -> ())?) {
        guard email == LOGIN_EMAIL && password == LOGIN_PASSWORD else {
            //TODO: Throw error
            completion?(nil, nil)
            return
        }
        
        request(url: Router.login()) { (jsonData, error) in
            if let jsonData = jsonData, let userData = jsonData["content"] as? [String: Any] {
                let user = User(dict: userData)
                self.currentUser = user
                completion?(user, error)
            }
        }
    }
    
    //MARK: - Helpers
    
    private func request(url: URLRequestConvertible, completion: (([String: Any]?, Error?) -> ())?) {
        Alamofire.request(url)
            .responseJSON { response in
                let error = response.result.error
                let jsonData = response.result.value as? [String: Any]
                
                completion?(jsonData, error)
        }
    }
}




