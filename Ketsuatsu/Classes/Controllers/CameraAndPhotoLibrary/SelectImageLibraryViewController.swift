//
//  SelectImageLibraryViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import Photos

class SelectImageLibraryViewController: BaseViewController {

    @IBOutlet weak var photoLibraryViewerContainer: UIView!
    lazy var albumView  = FSAlbumView.instance()
    var imageTaken:((UIImage) -> Void)?
    override func viewDidLoad() {
        super.viewDidLoad()
        photoLibraryViewerContainer.addSubview(albumView)
        self.view.bringSubview(toFront: photoLibraryViewerContainer)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        albumView.frame  = CGRect(origin: CGPoint.zero, size: photoLibraryViewerContainer.frame.size)
        albumView.layoutIfNeeded()
        
        albumView.initialize()
    }
    
    @IBAction func clickOK(_ sender: Any) {
        var factor: CGFloat?
        let ratioW = albumView.imageCropView.frame.width / (albumView.imageCropView.imageSize?.width)!
        let ratioH = albumView.imageCropView.frame.height / (albumView.imageCropView.imageSize?.height)!
        if ratioH > ratioW {
            factor = albumView.imageCropView.image.size.height/view.frame.width
        } else {
            factor = albumView.imageCropView.image.size.width/view.frame.width
        }

        let scale = 1/albumView.imageCropView.zoomScale
        let imageFrame = albumView.imageCropView.imageView.imageFrame()
        let x = (albumView.imageCropView.contentOffset.x  - imageFrame.origin.x) * scale * factor!
        let y = (albumView.imageCropView.contentOffset.y  - imageFrame.origin.y) * scale * factor!
        let width = albumView.imageCropViewContainer.frame.size.width * scale * factor!
        let height = albumView.imageCropViewContainer.frame.size.height * scale * factor!
       
        let croppedCGImage = albumView.imageCropView.imageView.image?.cgImage?.cropping(to: CGRect(x: x, y: y, width: width, height: height))
        let croppedImage = UIImage(cgImage: croppedCGImage!)

        if let block = imageTaken {
            block(croppedImage)
            self.dismiss(animated: true, completion: nil)
        }
    }
}

extension UIImageView{
    func imageFrame()->CGRect {
        let imageViewSize = self.frame.size
        guard let imageSize = self.image?.size else{return CGRect.zero}
        let imageRatio = imageSize.width / imageSize.height
        let imageViewRatio = imageViewSize.width / imageViewSize.height
        
        if imageRatio < imageViewRatio {
            let scaleFactor = imageViewSize.height / imageSize.height
            let width = imageSize.width * scaleFactor
            let topLeftX = (imageViewSize.width - width) * 0.5
            return CGRect(x: topLeftX, y: 0, width: width, height: imageViewSize.height)
        } else {
            let scalFactor = imageViewSize.width / imageSize.width
            let height = imageSize.height * scalFactor
            let topLeftY = (imageViewSize.height - height) * 0.5
            return CGRect(x: 0, y: topLeftY, width: imageViewSize.width, height: height)
        }
    }
}
