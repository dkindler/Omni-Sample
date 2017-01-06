//
//  SingleItemViewController.swift
//  Omni Sample
//
//  Created by Dan Kindler on 12/21/16.
//  Copyright © 2016 Dan Kindler. All rights reserved.
//

import UIKit
import AlamofireImage

class SingleItemViewController: UIViewController {
    var item: Item?
    
    @IBOutlet weak var imageScrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var checkoutButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = item?.title ?? item?.id
        itemLabel.text = item?.title
        categoryLabel.text = item?.category?.uppercased()
        pageControl.isHidden = true
        
        setupImageScrollView()
        setupCheckoutButton()
    }
    
    private func setupCheckoutButton() {
        if item == nil || item?.status == .notAvailable {
            checkoutButton.setTitle("Not Available :(", for: .normal)
            checkoutButton.isEnabled = false
        } else {
            checkoutButton.setTitle("Checkout", for: .normal)
            checkoutButton.isEnabled = true
        }
    }

    private func setupImageScrollView() {
        guard let images = item?.images else { return }
        
        imageScrollView.delegate = self
        let width = UIScreen.main.bounds.width
        
        // Normally we'd call `enumerated()` on images to get the index to calculate
        // the xCord, but we have no guarentee the string urls in `images` are valid URLs,
        // so we'll count ourselves
        var imageCount: CGFloat = 0
        for image in images {
            if let url = URL(string: image) {
                let frame = CGRect(x: width * imageCount, y: 0, width: width, height: width)
                let imageView = UIImageView(frame: frame)
                imageView.contentMode = UIViewContentMode.scaleAspectFill
                imageView.af_setImage(withURL: url, placeholderImage: PLACEHOLDER_IMAGE, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: UIImageView.ImageTransition.crossDissolve(0.5), runImageTransitionIfCached: false, completion: nil)
                imageScrollView.addSubview(imageView)
                imageCount += 1
            }
        }
        
        imageScrollView.contentSize = CGSize(width: width * imageCount, height: width)
        pageControl.numberOfPages = Int(imageCount)
        pageControl.isHidden = imageCount < 2
    }
}


// MARK: - ScrollView delegate

extension SingleItemViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard scrollView == imageScrollView else { return }
        
        let fractionalPage = scrollView.contentOffset.x / scrollView.bounds.width
        pageControl.currentPage = lround(Double(fractionalPage))
    }
}
