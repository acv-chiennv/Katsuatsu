//
//  PhotoPreviewViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit

class PhotoPreviewViewController: BaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var constraintHeightScrollView: NSLayoutConstraint!
    @IBOutlet weak var contraintHeightViewHeader: NSLayoutConstraint!
    
    @IBOutlet weak var constraintHeightImage: NSLayoutConstraint!
    @IBOutlet weak var constraintWidthImage: NSLayoutConstraint!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var viewBg: UIView!
    @IBOutlet weak var constraintHeightViewBg: NSLayoutConstraint!
    
    let widthScreen = UIScreen.main.bounds.width
    var imagePhoto: UIImage?
    var imageTaken:((UIImage) -> Void)?
    var height: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func initUI() {
        super.initUI()
        scrollView.delegate = self
        scrollView.maximumZoomScale = 10.0
        scrollView.minimumZoomScale = 1.0
        if IS_IPHONE_X {
            contraintHeightViewHeader.constant = 88.0
        }
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let image = imagePhoto else {
            return
        }
        constraintHeightViewBg.constant = image.size.height
        constraintWidthImage.constant = image.size.width
        constraintHeightImage.constant = image.size.height
        addLayerForImage(image.size.height)
        photo.image = image
    }
    
    @IBAction func invokeButtonBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btnOK_actionTouchUpInside(_ sender: Any) {
        
        let scale:CGFloat = 1 / scrollView.zoomScale
        let x:CGFloat = scrollView.contentOffset.x * scale
        let y:CGFloat = scrollView.contentOffset.y * scale
        var width:CGFloat = scrollView.frame.size.width * scale
        height = scrollView.frame.size.height * scale
        if scale == 1 {
            height = widthScreen
        }
        
        if width > height {
            width = height
        }else if width < height {
            
        }
        
        let croppedCGImage = photo.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: width))
        let croppedImage = UIImage(cgImage: croppedCGImage!)
        
        if let block = imageTaken {
            block(croppedImage)
            self.dismiss(animated: true, completion: nil)
        }
    }

    func cropImageView(imageView: UIImageView ,radius: CGFloat) -> UIImageView {
        
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = CGFloat(radius)
        imageView.clipsToBounds = true
        
        return imageView
    }
}

extension PhotoPreviewViewController {
    func addLayerForImage(_ height: CGFloat) -> Void {
        
        let radius = widthScreen / 2
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: widthScreen, height: height), cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width:2 * radius, height:2 * radius), cornerRadius: CGFloat(radius))
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.5
        viewBg.layer.addSublayer(fillLayer)
    }
}

extension PhotoPreviewViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return photo
    }
}
