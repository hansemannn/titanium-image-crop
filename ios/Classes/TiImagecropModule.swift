//
//  TiImagecropModule.swift
//  titanium-image-crop
//
//  Created by Your Name
//  Copyright (c) 2019 Your Company. All rights reserved.
//

import UIKit
import TitaniumKit

import CropViewController

@objc(TiImagecropModule)
class TiImagecropModule: TiModule {

  // MARK: Public constants
  
  @objc public let ASPECT_RATIO_SQUARE: Int = CropViewControllerAspectRatioPreset.presetSquare.rawValue
  @objc public let ASPECT_RATIO_3x2: Int = CropViewControllerAspectRatioPreset.preset3x2.rawValue
  @objc public let ASPECT_RATIO_5x3: Int = CropViewControllerAspectRatioPreset.preset5x3.rawValue
  @objc public let ASPECT_RATIO_4x3: Int = CropViewControllerAspectRatioPreset.preset4x3.rawValue
  @objc public let ASPECT_RATIO_5x4: Int = CropViewControllerAspectRatioPreset.preset5x4.rawValue
  @objc public let ASPECT_RATIO_7x5: Int = CropViewControllerAspectRatioPreset.preset7x5.rawValue
  @objc public let ASPECT_RATIO_16x9: Int = CropViewControllerAspectRatioPreset.preset16x9.rawValue
    
  @objc public let CropViewCroppingStyleDefault: Int = CropViewCroppingStyle.default.rawValue

  @objc public let CropViewCroppingStyleCircular: Int = CropViewCroppingStyle.circular.rawValue
    
  // MARK: Private config

  private var cropViewController: CropViewController?

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
    let croppingStyle = params["croppingStyle"]

    let aspectRatio = params["aspectRatio"]
    let doneButtonTitle = params["doneButtonTitle"] ?? NSLocalizedString("done", comment: "done")
    let cancelButtonTitle = params["cancelButtonTitle"] ?? NSLocalizedString("cancel", comment: "done")

    guard cropViewController == nil else { return }

    if croppingStyle as! String == "circular" {
        cropViewController = CropViewController(croppingStyle:CropViewCroppingStyle.circular, image: TiUtils.image(image, proxy: self))
    } else {
      cropViewController = CropViewController(croppingStyle:CropViewCroppingStyle.default, image: TiUtils.image(image, proxy: self))
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
      } else if let aspectRatio = aspectRatio as? Int, let rawAspectRatio = CropViewControllerAspectRatioPreset(rawValue: aspectRatio) {
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

extension TiImagecropModule : CropViewControllerDelegate {

  func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
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

    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
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

    
    
  func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
    self.fireEvent("done", with: ["cancel": true])

    self.cropViewController?.dismiss(animated: true, completion: {
      self.fireEvent("close")

      self.cropViewController?.delegate = nil
      self.cropViewController = nil
    })
  }
}
