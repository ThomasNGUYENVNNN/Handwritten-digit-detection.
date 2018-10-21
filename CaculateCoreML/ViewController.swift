//
//  ViewController.swift
//  CaculateCoreML
//
//  Created by Ngoc Phan on 9/23/18.
//  Copyright © 2018 NgocPhan. All rights reserved.
//

import UIKit
import Vision

extension UIImage {
  convenience init(view: UIView) {
    UIGraphicsBeginImageContext(view.frame.size)
    view.layer.render(in:UIGraphicsGetCurrentContext()!)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    self.init(cgImage: image!.cgImage!)
  }
}

class ViewController: UIViewController {
  @IBOutlet weak var drawableView: DrawableView!
  @IBOutlet weak var resultLabel: UILabel!

  var requests = [VNRequest]()

  override func viewDidLoad() {
    super.viewDidLoad()
    drawableView.backgroundColor = .black
    setupVisionModel()
  }

  private func setupVisionModel() {
    guard let visionModel = try? VNCoreMLModel(for: MNIST().model) else {
      fatalError("Could'nt load ML Model")
    }
    let classificationRequest = VNCoreMLRequest(model: visionModel, completionHandler: self.handleClassification)
    self.requests = [classificationRequest]
  }

  func handleClassification(request: VNRequest, error: Error?) {
    guard let observations = request.results else {
      print("No Result")
      return
    }
    let classifications = observations
      .compactMap({  $0 as? VNClassificationObservation })
      .filter({ $0.confidence > 0.9 })
      .map({ $0.identifier })
    
    DispatchQueue.main.async {
      self.resultLabel.text = classifications.first
    }
  }

  @IBAction func recognizeAction(_ sender: Any) {
    let image = UIImage(view: self.drawableView)
    let scaledImage = scaleImage(image: image, toSize: CGSize(width: 28, height: 28))

    let imageRequestHandler = VNImageRequestHandler(cgImage: scaledImage.cgImage!, options: [:])

    do {
      try imageRequestHandler.perform(self.requests)
    } catch let error {
      print(error)
    }
  }

  func scaleImage(image: UIImage, toSize size: CGSize) -> UIImage {
    UIGraphicsBeginImageContextWithOptions(size, false, 1)
    image.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
    let newImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return newImage!
  }

  @IBAction func clearAction(_ sender: Any) {
    drawableView.clear()
    resultLabel.text = nil
  }
}
