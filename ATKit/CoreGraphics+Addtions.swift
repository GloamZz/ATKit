//
//  CoreGraphics+Addtions.swift
//  CGAffineTransform
//
//  Created by Sylvan on 2023/8/18.
//

import CoreGraphics

extension CGRect {
    init(center: CGPoint, size: CGSize) {
        self.init(x: center.x - size.width / 2.0,
                  y: center.y - size.height / 2.0,
                  width: size.width,
                  height: size.height)
    }
}

extension CGAffineTransform {
    var xScale: CGFloat {
        return a
    }
    
    var yScale: CGFloat {
        return d
    }
    
    var angle: CGFloat {
        return atan(b / a) / CGFloat.pi * 180.0
    }
    
    var rotate: CGFloat {
        return atan(b / a)
    }
    
    var xTranslation: CGFloat {
        return tx
    }
    
    var yTranslation: CGFloat {
        return ty
    }
}

