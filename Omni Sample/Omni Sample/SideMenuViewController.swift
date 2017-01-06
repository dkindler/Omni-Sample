//
//  SideMenuViewController.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/22/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import AlamofireImage

class SideMenuViewController: UIViewController {

    @IBOutlet weak var avatarImageView: CircleImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let user = OmniWebManager.shared.getCurrentUser() {
            nameLabel.text = user.fullName()
            emailLabel.text = user.email
            if let avatarUrlString = user.avatar, let url = URL(string: avatarUrlString) {
                avatarImageView.af_setImage(withURL: url, placeholderImage: PLACEHOLDER_IMAGE, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: false, completion: nil)
            }
        }
    }

    @IBAction func logoutPressed(_ sender: Any) {
        if let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "login") as? LoginViewController {
            OmniWebManager.shared.logout()
            self.present(loginVC, animated: false, completion: nil)
        }
    }
}
