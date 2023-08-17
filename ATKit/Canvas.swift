//
//  Canvas.swift
//  CGAffineTransform
//
//  Created by Sylvan on 2023/8/18.
//

import UIKit

class Canvas: UIView {

    lazy var renderView: UIView = {
        let view = UIView.init(frame: .init(center: .init(x: bounds.midX,
                                                          y: bounds.midY),
                                            size: .init(width: bounds.width / 2.0,
                                                        height: bounds.height / 3.0)))
        view.backgroundColor = .green
        addSubview(view)
        return view
    }()
    
    
    var drawingTransform: CGAffineTransform = .identity {
        didSet {
            renderView.transform = drawingTransform
//            setNeedsDisplay()
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        drawingTransform = drawingTransform.rotated(by: CGFloat.pi / 180.0 / 3)
    }
    /*
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let baseRect = CGRect.init(center: .init(x: rect.midX, y: rect.midY),
                                   size: .init(width: rect.width / 3.0, height: rect.height / 3.0))
        
        let (topLeft,
             topRight,
             bottomLeft,
             bottomRight) = (
                CGPoint.init(x: baseRect.minX, y: baseRect.minY).applying(drawingTransform),
                CGPoint.init(x: baseRect.maxX, y: baseRect.minY).applying(drawingTransform),
                CGPoint.init(x: baseRect.minX, y: baseRect.maxY).applying(drawingTransform),
                CGPoint.init(x: baseRect.maxX, y: baseRect.maxY).applying(drawingTransform)
        )
                
//        let path = UIBezierPath.init()
//        path.move(to: topLeft)
//        path.addLine(to: topRight)
//        path.addLine(to: bottomRight)
//        path.addLine(to: bottomLeft)
//        path.addLine(to: topLeft)
//        path.fill()
        
        let context = UIGraphicsGetCurrentContext()!
        UIColor.green.setFill()
        context.fill([baseRect.applying(drawingTransform)])
//        context.addPath(path.cgPath)
    }
     */
}
