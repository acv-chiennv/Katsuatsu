//
//  CameraViewController.swift
//  Ketsuatsu
//
//  Created by NguyenVanChien on 4/6/18.
//  Copyright © 2018 NguyenVanChien. All rights reserved.
//

import UIKit
import AVFoundation

class CameraViewController: BaseViewController {

    fileprivate var capturePhotoOutput: AVCapturePhotoOutput?
    var captureSession: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var captureDevice: AVCaptureDevice!
    var captureInput: AVCaptureInput!
    let widthScreen = UIScreen.main.bounds.width
    var isCheckCamera = false
    var widthViewCamera: CGFloat = 0.0
    var takePhoto = false
    var imageTaken: ((UIImage) -> Void)?
    
    @IBOutlet weak var viewCamera: UIView!
    @IBOutlet weak var contraintHeightViewHeader: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.prepareCamera()
        }
        setCamera()
        widthViewCamera = UIScreen.main.bounds.width
        if IS_IPHONE_X {
            contraintHeightViewHeader.constant = 88.0
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    
    }

    @IBAction func invokeButtonTakePhoto(_ sender: Any) {
        takePhoto = true
        guard let capturePhotoOutput = capturePhotoOutput else {
            return
        }
        let photoSetting = AVCapturePhotoSettings()
        photoSetting.isAutoStillImageStabilizationEnabled = true
        photoSetting.flashMode = .off
        capturePhotoOutput.capturePhoto(with: photoSetting, delegate: self)
    }
    
    @IBAction func invokeButtonBack(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func invokeButtonChooseLibrary(_ sender: Any) {
        let libraryVC = UIUtils.viewControllerWithIndentifier(identifier:IMAGE_LIBRARY_VIEWCONTROLLER_IDENTIFIER, storyboardName: "Main") as! SelectImageLibraryViewController
        libraryVC.imageTaken = { image in
            if let block = self.imageTaken {
                block(image)
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.present(libraryVC, animated: true, completion: nil)
    }
}

extension CameraViewController {
    
    func prepareCamera() -> Void {
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSession.Preset.photo
        
        guard let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: AVMediaType.video, position: .back) else {
            return
        }
        var error: NSError?
        var input: AVCaptureDeviceInput!
        
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
            
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && captureSession!.canAddInput(input) {
            captureSession!.addInput(input)
            capturePhotoOutput = AVCapturePhotoOutput()
            guard capturePhotoOutput != nil else {
                return
            }
            if captureSession!.canAddOutput(capturePhotoOutput!) {
                captureSession!.addOutput(capturePhotoOutput!)
                let radius = widthViewCamera / 2
                self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
                self.previewLayer?.frame = self.viewCamera.bounds
                self.previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
                let path = UIBezierPath(roundedRect: CGRect.init(x: 0, y: 0, width: widthScreen, height: self.viewCamera.bounds.height), cornerRadius: 0)
                let circlePath = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width:2 * radius, height:2 * radius), cornerRadius: CGFloat(radius))
                path.append(circlePath)
                path.usesEvenOddFillRule = true
                let fillLayer = CAShapeLayer()
                fillLayer.path = path.cgPath
                fillLayer.fillRule = kCAFillRuleEvenOdd
                fillLayer.fillColor = UIColor.black.cgColor
                fillLayer.opacity = 0.5
                
                self.previewLayer?.addSublayer(fillLayer)
                self.viewCamera.layer.addSublayer(self.previewLayer!)
                captureSession!.startRunning()
            }
        }
    }
    
    func setCamera() -> Void {
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back ).devices
        do {
            try self.captureSession?.removeInput(AVCaptureDeviceInput(device: self.captureDevice))
        } catch {
            print("error")
        }
        for device in devices {
            if (device as AVCaptureDevice).hasMediaType(AVMediaType.video) {
                if device.position == AVCaptureDevice.Position.back {
                    self.captureDevice = device
                    do {
                        try self.captureSession?.addInput(AVCaptureDeviceInput(device: self.captureDevice))
                    }catch {
                        
                    }
                    break
                }
            }
        }
    }
}

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
                print("Error capturing photo: \(String(describing: error))")
                return
        }
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        let capturedImage = UIImage.init(data: imageData , scale: 1.0)
        let image = resizeImage(image: capturedImage!, newWidth: self.widthViewCamera)
        
        let photoPreviewVC = PhotoPreviewViewController(nibName: "PhotoPreviewViewController", bundle: nil)
        photoPreviewVC.imagePhoto = image
        photoPreviewVC.imageTaken = { image in
            if let block = self.imageTaken {
                block(image)
                self.navigationController?.popViewController(animated: true)
            }
        }
        self.present(photoPreviewVC, animated: true, completion: nil)
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage? {
        
                let scale = newWidth / image.size.width
                let newHeight = image.size.height * scale
                UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
                image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
        
                return newImage
            }
}
