//
//  TiImagecropModule.swift
//  titanium-image-crop
//
//  Created by Your Name
//  Copyright (c) 2019 Your Company. All rights reserved.
//

import UIKit
import TitaniumKit

import TOCropViewController

@objc(TiImagecropModule)
class TiImagecropModule: TiModule {

  // MARK: Public constants
  
  @objc public let ASPECT_RATIO_SQUARE: Int = TOCropViewControllerAspectRatioPreset.presetSquare.rawValue
  @objc public let ASPECT_RATIO_3x2: Int = TOCropViewControllerAspectRatioPreset.preset3x2.rawValue
  @objc public let ASPECT_RATIO_5x3: Int = TOCropViewControllerAspectRatioPreset.preset5x3.rawValue
  @objc public let ASPECT_RATIO_4x3: Int = TOCropViewControllerAspectRatioPreset.preset4x3.rawValue
  @objc public let ASPECT_RATIO_5x4: Int = TOCropViewControllerAspectRatioPreset.preset5x4.rawValue
  @objc public let ASPECT_RATIO_7x5: Int = TOCropViewControllerAspectRatioPreset.preset7x5.rawValue
  @objc public let ASPECT_RATIO_16x9: Int = TOCropViewControllerAspectRatioPreset.preset16x9.rawValue
    
  @objc public let CropViewCroppingStyleDefault: Int = TOCropViewCroppingStyle.default.rawValue

  @objc public let CropViewCroppingStyleCircular: Int = TOCropViewCroppingStyle.circular.rawValue
    
  // MARK: Private config
  
  private var cropViewController: TOCropViewController?
  
  func moduleGUID() -> String {
    return "0b0ea922-0b5a-493e-826b-596a54904a8c"
  }
  
  override func moduleId() -> String! {
    return "ti.imagecrop"
  }

  // MARK: Public APIs

  @objc(showCropDialog:)
  func showCropDialog(arguments: Array<Any>?) {
    // Validate basic usage
    guard let params = arguments?.first as? [String: Any], let image = params["image"] else {
      debugPrint("[ERROR] No valid image provided")
      return
    }

    // List proxy properties
    let croppingStyle = params["croppingStyle"] ?? NSString("default")
    let aspectRatio = params["aspectRatio"]
    let doneButtonTitle = params["doneButtonTitle"] ?? NSLocalizedString("done", comment: "done")
    let cancelButtonTitle = params["cancelButtonTitle"] ?? NSLocalizedString("cancel", comment: "done")

    guard cropViewController == nil else { return }

    
    if croppingStyle as! String == "circular"{
        cropViewController = TOCropViewController(croppingStyle:TOCropViewCroppingStyle.circular, image: TiUtils.image(image, proxy: self))
      }
    else {
        cropViewController = TOCropViewController(croppingStyle:TOCropViewCroppingStyle.default, image: TiUtils.image(image, proxy: self))
    }
    
    
    guard let cropViewController = cropViewController else { return }
    
    // Apply general config
      

      
    cropViewController.delegate = self
    cropViewController.doneButtonTitle = doneButtonTitle as? String
    cropViewController.cancelButtonTitle = cancelButtonTitle as? String
    
    // Handle both raw aspect ratios and presets (square, 16/9)
    if let aspectRatio = aspectRatio {
      // Handle raw values
      if let aspectRatio = aspectRatio as? [String: Int] {
        if let x = aspectRatio["x"], let y = aspectRatio["y"] {
          cropViewController.customAspectRatio = CGSize(width: x, height: y)
        }
      // Handle presets
      } else if let aspectRatio = aspectRatio as? Int, let rawAspectRatio = TOCropViewControllerAspectRatioPreset(rawValue: aspectRatio) {
        cropViewController.aspectRatioPreset = rawAspectRatio
      } else {
        debugPrint("[ERROR] No valid aspect ratio provided!")
      }
    } else {
      cropViewController.aspectRatioPreset = .presetSquare
    }
  
    // Request top-most VC
    guard let controller = TiApp.controller(), let topPresentedController = controller.topPresentedController() else { return }
    topPresentedController.present(cropViewController, animated: true, completion: nil)
  }
}

// MARK: CropViewControllerDelegate

extension TiImagecropModule : TOCropViewControllerDelegate {

    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
    guard let blob = TiBlob(image: image) else {
      return
    }

    self.fireEvent("done", with: ["image": blob, "cancel": false])

    self.cropViewController?.dismiss(animated: true, completion: {
      self.fireEvent("close")

      self.cropViewController?.delegate = nil
      self.cropViewController = nil
    })
  }

    func cropViewController(_ cropViewController: TOCropViewController, didCropToCircularImage image: UIImage, with cropRect: CGRect, angle: Int) {
      guard let blob = TiBlob(image: image) else {
        return
      }

      self.fireEvent("done", with: ["image": blob, "cancel": false])

      self.cropViewController?.dismiss(animated: true, completion: {
        self.fireEvent("close")

        self.cropViewController?.delegate = nil
        self.cropViewController = nil
      })
    }

    
    
  func cropViewController(_ cropViewController: TOCropViewController, didFinishCancelled cancelled: Bool) {
    self.fireEvent("done", with: ["cancel": true])

    self.cropViewController?.dismiss(animated: true, completion: {
      self.fireEvent("close")

      self.cropViewController?.delegate = nil
      self.cropViewController = nil
    })
  }
}
