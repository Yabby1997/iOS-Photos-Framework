//
//  ImageZoomViewController.swift
//  Photos Framework
//
//  Created by Seunghun Yang on 2021/03/14.
//

import UIKit
import Photos

class ImageZoomViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!
    
    // MARK: - Properties
    var asset: PHAsset!
    let imageManager: PHCachingImageManager = PHCachingImageManager()
    
    // MARK: - View Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.scrollView.delegate = self
        
        let option: PHImageRequestOptions = PHImageRequestOptions()
        option.resizeMode = .exact
        
        imageManager.requestImage(
            for: asset,
            targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
            contentMode: .aspectFill,
            options: option,
            resultHandler: { image, _ in
                self.imageView.image = image
        })
    }
    
    // MARK: - UIScrollViewDelegate Methods
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
