//
//  SRCircleProgress.swift
//  ShareDiary
//
//  Created by Ryu on 2022/06/11.
//

import UIKit
import SnapKit

open class SRCircleProgress: UIView {

    public var progress: CGFloat {
        get {
            progressLayer.strokeEnd
        }
        set {
            progressLayer.strokeEnd = newValue
        }
    }

    public var progressColor: UIColor = .systemBlue {
        didSet {
            progressLayer.strokeColor = progressColor.cgColor
        }
    }

    public var circleBackgroundColor: UIColor = .systemBackground {
        didSet {
            circleLayer.strokeColor = circleBackgroundColor.cgColor
        }
    }

    public var progressLineWidth: CGFloat = 10 {
        didSet {
            progressLayer.lineWidth = progressLineWidth
        }
    }

    public var backgroundLineWidth: CGFloat = 20.0 {
        didSet {
            circleLayer.lineWidth = backgroundLineWidth
        }
    }

    public var animationDuration: TimeInterval = 0.2

    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    override public init(frame: CGRect) {
        super.init(frame: frame)
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open func layoutSubviews() {
        super.layoutSubviews()
        createCircularPath()
    }

    private func createCircularPath() {
        // created circularPath for circleLayer and progressLayer
        let offset = backgroundLineWidth > progressLineWidth ? backgroundLineWidth : progressLineWidth
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0),
            radius: frame.size.width / 2 - offset,
            startAngle: startPoint,
            endAngle: endPoint,
            clockwise: true
        )
        // circleLayer path defined to circularPath
        circleLayer.path = circularPath.cgPath
        // ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = backgroundLineWidth
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = circleBackgroundColor.cgColor
        // added circleLayer to layer
        layer.addSublayer(circleLayer)
        // progressLayer path defined to circularPath
        progressLayer.path = circularPath.cgPath
        // ui edits
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = progressLineWidth
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = progressColor.cgColor
        // added progressLayer to layer
        layer.addSublayer(progressLayer)
    }

    open func setProgress(_ progress: CGFloat, animated: Bool) {
        if animated {
            let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
            // set the end time
            circularProgressAnimation.duration = animationDuration
            circularProgressAnimation.toValue = progress
            circularProgressAnimation.fillMode = .forwards
            circularProgressAnimation.isRemovedOnCompletion = false
            progressLayer.add(circularProgressAnimation, forKey: "progress")
        } else {
            self.progress = progress
        }
    }

}
