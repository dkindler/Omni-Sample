//
//  ItemCollectionViewCell.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import AlamofireImage

class ItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: CircleImageView!
    @IBOutlet weak var itemLabel: UILabel!
    
    var item: Item? {
        didSet {
            setupForItem()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.layer.borderColor = UIColor.lightGray.cgColor
        imageView.layer.borderWidth = 1
        imageView.layoutIfNeeded()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
        imageView.af_cancelImageRequest()
    }
    
    func setupForItem() {
        guard let item = item else { return }
        if let stringUrl = item.image, let imageUrl = URL(string: stringUrl) {
            let urlRequest = URLRequest(url: imageUrl)
            imageView.af_setImage(withURLRequest: urlRequest, placeholderImage: PLACEHOLDER_IMAGE, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: false, completion: nil)
        }
        
        itemLabel.text = item.title
    }
}
