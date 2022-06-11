//
//  LoadingView.swift
//  TraderLand
//
//  Created by Mark Lai on 13/4/2022.
//

import UIKit

class LoadingView: UIView {
    
    fileprivate let cycleLayer: CAShapeLayer = CAShapeLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setupView() {

        cycleLayer.lineWidth = 8
        cycleLayer.fillColor = UIColor.clear.cgColor
        cycleLayer.strokeColor = UIColor.orange.cgColor
        
        cycleLayer.lineCap = CAShapeLayerLineCap.round
        cycleLayer.lineJoin = CAShapeLayerLineJoin.round
        
        cycleLayer.frame = bounds
        cycleLayer.path = UIBezierPath(ovalIn: bounds).cgPath
        layer.addSublayer(cycleLayer)
    }
    
    func startLoading() {
        let strokeStartAnimation = CABasicAnimation(keyPath: "strokeStart")
        strokeStartAnimation.fromValue = -1
        strokeStartAnimation.toValue = 1.0
        strokeStartAnimation.repeatCount = Float.infinity
        cycleLayer.add(strokeStartAnimation, forKey: "strokeStartAnimation")

        let strokeEndAnimation = CABasicAnimation(keyPath: "strokeEnd")
        strokeEndAnimation.fromValue = 0
        strokeEndAnimation.toValue = 1.0
        strokeEndAnimation.repeatCount = Float.infinity
        cycleLayer.add(strokeEndAnimation, forKey: "strokeStartAnimation")

        let animationGroup = CAAnimationGroup()
        animationGroup.repeatCount = Float.infinity
        animationGroup.animations = [strokeStartAnimation, strokeEndAnimation]
        animationGroup.duration = 1.0
        cycleLayer.add(animationGroup, forKey: "animationGroup")

        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0
        rotateAnimation.toValue = Double.pi * 2
        rotateAnimation.repeatCount = Float.infinity
        rotateAnimation.duration = 1.0 * 3
        cycleLayer.add(rotateAnimation, forKey: "rotateAnimation")
    }
}
