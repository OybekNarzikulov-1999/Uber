//
//  CircularProgressView.swift
//  Uber
//
//  Created by Oybek Narzikulov on 24/11/22.
//

import UIKit

class CircularProgressView: UIView {

    // MARK: - Properties
    
    var progressLayer: CAShapeLayer!
    var trackLayer: CAShapeLayer!
    var pulsatingLayer: CAShapeLayer!
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureCircleLayers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Helper Methods

    private func configureCircleLayers(){
        pulsatingLayer = circleShapeLayer(strokeColor: .clear, fillColor: UIColor(red: 86/255, green: 30/255, blue: 63/255, alpha: 1))
        layer.addSublayer(pulsatingLayer)
        
        trackLayer = circleShapeLayer(strokeColor: UIColor(red: 56/255, green: 25/255, blue: 49/255, alpha: 1), fillColor: .clear)
        layer.addSublayer(trackLayer)
        trackLayer.strokeEnd = 1
        
        progressLayer = circleShapeLayer(strokeColor: UIColor(red: 234/255, green: 46/255, blue: 111/255, alpha: 1), fillColor: .clear)
        layer.addSublayer(progressLayer)
        progressLayer.strokeEnd = 1
    }
    
    private func circleShapeLayer(strokeColor: UIColor, fillColor: UIColor) -> CAShapeLayer{
        let layer = CAShapeLayer()
        
        let center = CGPoint(x: 0, y: 32)
        let circularPath = UIBezierPath(arcCenter: center, radius: self.frame.width / 2.5, startAngle: -(.pi / 2), endAngle: 1.5 * .pi, clockwise: true)
        
        layer.path = circularPath.cgPath
        layer.strokeColor = strokeColor.cgColor
        layer.lineWidth = 12
        layer.fillColor = fillColor.cgColor
        layer.lineCap = .round
        layer.position = self.center
        
        return layer
    }
    
    func animatePulsatingLayer(){
        
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.25
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
        
    }
    
    func setProgressWithAnimation(duration: TimeInterval, value: Float, completion: @escaping() -> Void){
        
        CATransaction.begin()
        CATransaction.setCompletionBlock(completion)
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 1
        animation.toValue = value
        animation.timingFunction = CAMediaTimingFunction(name: .linear)
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(animation, forKey: "AnimateProgress")
        
        CATransaction.commit()
        
    }
    
}
