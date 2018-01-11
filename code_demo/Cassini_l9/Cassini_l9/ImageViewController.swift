//
//  ImageViewController.swift
//  Cassini_l9
//
//  Created by XueYu on 12/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // model
    var imageUrl: URL? {
        didSet {
            // reset the image in imageView
            imageView.image = nil
            // because fetch image is expensive, we only want to fetch it if needed, we can use this view.window != nil to make sure the view is on screen
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    // computed property, we'll get from the UIImageView
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            // everytime we set it, we also change the scrollView contentSize, this is the most important since only with this we can really scroll the scroll view
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView.contentSize = imageView.frame.size
        }
    }
    
    
    
    // maybe this would fetch from network, so we make it a func
    private func fetchImage()  {
        if let url = imageUrl {
            // get the bag of bites form url, because it throws, so we use try?, and urlContents is data?
            let urlContents = try? Data(contentsOf: url)
            if let imageData = urlContents {
                image = UIImage(data: imageData)
            }
        }
    }
    
    // because fetch image is expensive, we only want to fetch it if needed
    override func viewDidAppear(_ animated: Bool) {
        // always use super
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if imageUrl == nil {
            imageUrl = DemoURLs.stanford
        }
    }
    
    var imageView = UIImageView()
    
    // make sure whenever the scrollView is initialized, we add the imageView to it
    // also set the zoom parameter and make zoom work
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    
    // implementing zooming
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
