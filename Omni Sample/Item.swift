//
//  Item.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import Foundation

class Item: NSObject {
    enum Status {
        case checkedIn
        case notAvailable
    }
    
    var category: String?
    var id: String?
    var image: String?
    var imageThumbnail: String?
    var images: [String]?
    var stackId: String?
    var stackSize: Int?
    var title: String?
    var status: Status
    
    override var description: String {
        return "\(title ?? "") <\(id ?? "No Email")>"
    }
    
    init(dict: [String: Any]) {
        self.category = dict["category"] as? String
        self.image = dict["image"] as? String
        self.id = dict["id"] as? String
        self.imageThumbnail = dict["image_thumbnail"] as? String
        self.images = dict["images"] as? [String]
        self.stackId = dict["stack_id"] as? String
        self.stackSize = dict["stack_size"] as? Int
        self.title = dict["title"] as? String
        
        if let status = dict["status"] as? String, status == "Checked-in" {
            self.status = .checkedIn
        } else {
            self.status = .notAvailable
        }
    }
}
