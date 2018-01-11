//
//  ImageViewController.swift
//  Cassini_l9
//
//  Created by XueYu on 12/28/17.
//  Copyright © 2017 XueYu. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    var imageUrl: URL? {
        didSet {
            imageView.image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            // we use this optinal way because when we try to set the imageUrl, it will trigger the fetch Image, and here the scrollView outlet not exists
            scrollView?.contentSize = imageView.frame.size
            // every time we set the image, we stop it
            spinner?.stopAnimating()
        }
    }
    
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    private func fetchImage()  {
        if let url = imageUrl {
            // more responsive
            spinner.startAnimating()
            // we should not run on this main queue since it's not UI thing
            // userInitiated -  high priority, but might take a little bit of time
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                // if someone touches back, this self would be kept in the heap, so we use weak self
                // not about memory cycles, but donot want it be kept in the heap
                // hanging here, so we add multi-threading above
                let urlContents = try? Data(contentsOf: url)
                // UIImageView.image must be used from main thread only, this put the UI back
                DispatchQueue.main.async {
                    // make sure it is the url we're trying to fetch
                    if let imageData = urlContents, url == self?.imageUrl {
                        self?.image = UIImage(data: imageData)
                    }
                    
                }

            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if imageView.image == nil {
            fetchImage()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // since we are using the web url to set it now
//        if imageUrl == nil {
//            imageUrl = DemoURLs.stanford
//        }
    }
    
    private var imageView = UIImageView()
    

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet{
            scrollView.minimumZoomScale = 1/25
            scrollView.maximumZoomScale = 1.0
            scrollView.delegate = self
            scrollView.addSubview(imageView)
        }
    }
    
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
