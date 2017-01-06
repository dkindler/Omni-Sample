//
//  User.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import Foundation

class User: NSObject, NSCoding {
    var avatar: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    
    override var description: String {
        return "\(firstName ?? "") \(lastName ?? "") <\(email ?? "No Email")>"
    }
    
    required init(coder decoder: NSCoder) {
        self.firstName = decoder.decodeObject(forKey: "firstName") as? String
        self.lastName = decoder.decodeObject(forKey: "lastName") as? String
        self.email = decoder.decodeObject(forKey: "email") as? String
        self.avatar = decoder.decodeObject(forKey: "avatar") as? String
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(firstName, forKey: "firstName")
        coder.encode(lastName, forKey: "lastName")
        coder.encode(email, forKey: "email")
        coder.encode(avatar, forKey: "avatar")
    }
    
    init(dict: [String: Any]) {
        self.firstName = dict["first_name"] as? String
        self.lastName = dict["last_name"] as? String
        self.email = dict["email"] as? String
        self.avatar = dict["avatar"] as? String
    }
    
    func fullName() -> String {
        return "\(firstName ?? "") \(lastName ?? "")"
    }
}
