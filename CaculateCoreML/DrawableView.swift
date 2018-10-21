//
//  DrawableView.swift
//  CaculateCoreML
//
//  Created by Ngoc Phan on 9/23/18.
//  Copyright © 2018 NgocPhan. All rights reserved.
//

import UIKit

class DrawableView: UIView {

  var lineColor: UIColor = UIColor.white
  var lineWidth: CGFloat = 10
  var path: UIBezierPath!
  var touchPoint: CGPoint!
  var startingPoint: CGPoint!

  override func layoutSubviews() {
  
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    self.isMultipleTouchEnabled = false
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    startingPoint = touch?.location(in: self)
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    let touch = touches.first
    touchPoint = touch?.location(in: self)

    path = UIBezierPath()
    path.move(to: startingPoint)
    path.addLine(to: touchPoint)
    startingPoint = touchPoint

    drawShapeLayer()
  }

  private func drawShapeLayer() {
    let shapeLayer = CAShapeLayer()
    shapeLayer.path = path.cgPath
    shapeLayer.strokeColor = lineColor.cgColor
    shapeLayer.fillColor = UIColor.clear.cgColor
    shapeLayer.lineWidth = lineWidth
    layer.addSublayer(shapeLayer)
    setNeedsDisplay()
  }

  func clear() {
    path.removeAllPoints()
    self.layer.sublayers = nil
      setNeedsDisplay()
  }
}
