//
//  FSAlbumView.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import Photos

final class FSAlbumView: UIView, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageCropView: FSImageCropView!
    @IBOutlet weak var imageCropViewContainer: UIView!
    
    @IBOutlet weak var collectionViewConstraintHeight: NSLayoutConstraint!
    
    var images: PHFetchResult<PHAsset>!
    var imageSelect = UIImage()
    var imageManager: PHCachingImageManager?
    let cellSize = CGSize(width: 100, height: 100)
    var phAsset: PHAsset!
    let keyIsAuthenLibrary = "keyIsAuthenLibrary"
    let itemPerRow: CGFloat = 3
    
    static func instance() -> FSAlbumView {
        return UINib(nibName: "FSAlbumView", bundle: Bundle(for: self.classForCoder())).instantiate(withOwner: self, options: nil)[0] as! FSAlbumView
    }
    
    func initialize() {
        
        if images != nil {
            return
        }
		
		self.isHidden = false
        collectionViewConstraintHeight.constant = self.frame.height - imageCropViewContainer.frame.height
        
        // Create circle View
        let radius = self.imageCropViewContainer.frame.width/2
        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.imageCropViewContainer.bounds.size.width, height: self.imageCropViewContainer.bounds.size.height), cornerRadius: 0)
        let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: 2 * radius, height: 2 * radius), cornerRadius: radius)
        path.append(circlePath)
        path.usesEvenOddFillRule = true
        
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.cgPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.black.cgColor
        fillLayer.opacity = 0.5
        
        self.imageCropViewContainer.layer.addSublayer(fillLayer)
        
        collectionView.register(UINib(nibName: "FSAlbumViewCell", bundle: Bundle(for: self.classForCoder)), forCellWithReuseIdentifier: "FSAlbumViewCell")
        
        // Never load photos Unless the user allows to access to photo album
        var isAuthenLibrary = Bool()
        let defaults = UserDefaults.standard
        isAuthenLibrary = (defaults.value(forKey: keyIsAuthenLibrary) != nil)
        if isAuthenLibrary {
            getImageFromLibrary()
        }
        else
        {
            checkPhotoAuth()
        }
    }
    
    func getImageFromLibrary() -> Void {
        // Get Image and Sorting condition
        self.imageManager = PHCachingImageManager()
        let options = PHFetchOptions()
        options.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: false)
        ]
        images = PHAsset.fetchAssets(with: .image, options: options)
        
        if images.count > 0 {
            changeImage(images[0])
            // set imageSelected default = first image
            let asset = self.images[0]
            self.imageManager?.requestImage(for: asset,
                                            targetSize: cellSize,
                                            contentMode: .aspectFill,
                                            options: nil) {
                                                result, info in
                                                self.imageSelect = result!
            }
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: false, scrollPosition: UICollectionViewScrollPosition())
        }
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension FSAlbumView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FSAlbumViewCell", for: indexPath) as! FSAlbumViewCell
        var index = indexPath.item
        if index % 3 == 0 && (self.images.count - index) > 2 {
            index = index + 2
        }
        else if index % 3 == 2 {
            index = index - 2
        }
        let asset = self.images[index]
        
        self.imageManager?.requestImage(for: asset,
                                        targetSize: cellSize,
                                        contentMode: .aspectFill,
                                        options: nil) {
                                            result, info in
                                            cell.image = result
        }
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return images == nil ? 0 : images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = CGFloat(2)
        let availableWidth = collectionView.frame.width - paddingSpace
        let widthPerItem = availableWidth/itemPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(1)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var index = indexPath.item
        
        if index % 3 == 0 && (self.images.count - index) > 2 {
            index = index + 2
        }
        else if index % 3 == 2 {
            index = index - 2
        }
        
        changeImage(images[index])
        
        // set image want to pass = imageSelected
        let asset = self.images[index]
        self.imageManager?.requestImage(for: asset,
                                        targetSize: cellSize,
                                        contentMode: .aspectFill,
                                        options: nil) {
                                            result, info in
                                            self.imageSelect = result!
        }
        
        imageCropView.changeScrollable(true)
        collectionViewConstraintHeight.constant = self.frame.height - imageCropViewContainer.frame.height
        
        UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions.curveEaseOut, animations: {
            
            self.layoutIfNeeded()
            
        }, completion: nil)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: true)
    }
}

private extension FSAlbumView {
    
    func changeImage(_ asset: PHAsset) {
        self.imageCropView.image = nil
        self.phAsset = asset
        
        DispatchQueue.global(qos: .default).async(execute: {
            
            let options = PHImageRequestOptions()
            options.isNetworkAccessAllowed = true
            
            self.imageManager?.requestImage(for: asset,
                targetSize: CGSize(width: asset.pixelWidth, height: asset.pixelHeight),
                contentMode: .aspectFill,
                options: options) {
                    result, info in
                    DispatchQueue.main.async(execute: {
                        self.imageCropView.imageSize = CGSize(width: asset.pixelWidth, height: asset.pixelHeight)
                        self.imageCropView.image = result
                    })
            }
        })
    }
    
    // Check the status of authorization for PHPhotoLibrary
    func checkPhotoAuth() {
        PHPhotoLibrary.requestAuthorization { (status) -> Void in
            switch status {
            case .authorized:
                let defaults = UserDefaults.standard
                defaults.set(true, forKey: self.keyIsAuthenLibrary)
                self.getImageFromLibrary()
                break
            case .restricted, .denied:
                break
            default:
                break
            }
        }
    }
}
