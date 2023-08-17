//
//  ATFactory.swift
//  CGAffineTransform
//
//  Created by Sylvan on 2023/8/18.
//

import Foundation

enum ATApplyOrder: String, CaseIterable {
    case bySTR = "STR"
    case bySRT = "SRT"
    case byTSR = "TSR"
    case byTRS = "TRS"
    case byRST = "RST"
    case byRTS = "RTS"
    
    var title: String {
        switch self {
        case .bySTR:
            return "Scale -> Translation -> Rotate"
        case .bySRT:
            return "Scale -> Rotate -> Translation"
        case .byTSR:
            return "Translation -> Scale -> Rotate"
        case .byTRS:
            return "Translation -> Rotate -> Scale"
        case .byRST:
            return "Rotate -> Scale -> Translation"
        case .byRTS:
            return "Rotate -> Translation -> Scale"
        }
    }
}

enum ATComponent: String, CaseIterable {
    case x = "x"
    case y = "y"
    case scaleX = "scale x"
    case scaleY = "scale y"
    case rotate = "rotate"
    
    var name: String  {
        return rawValue
    }
    
    var defaultValue: CGFloat  {
        switch self {
        case .x:
            return 0
        case .y:
            return 0
        case .scaleX:
            return 1
        case .scaleY:
            return 1
        case .rotate:
            return 0
        }
    }
    var maximumValue: CGFloat  {
        switch self {
        case .x:
            return 1000
        case .y:
            return 1000
        case .scaleX:
            return 10
        case .scaleY:
            return 10
        case .rotate:
            return CGFloat.pi * 2
        }
    }
    var minimumValue: CGFloat {
        switch self {
        case .x:
            return -1000
        case .y:
            return -1000
        case .scaleX:
            return -10
        case .scaleY:
            return -10
        case .rotate:
            return -CGFloat.pi * 2
        }
    }
}

class ATFactory {
    typealias X = CGFloat
    typealias Y = CGFloat
    typealias ScaleX = CGFloat
    typealias ScaleY = CGFloat
    typealias Rotate = CGFloat

    var transforms: [(X, Y, ScaleX, ScaleY, Rotate)] = []

    func reset() {
        transforms.removeAll()
    }
    
    func add() {
        transforms.append((0, 0, 1, 1, 0))
    }
    
    func modify(at index: Int, for component: ATComponent, value: CGFloat) {
        let (x, y, scaleX, scaleY, rotate) = transforms[index]
        
        switch component {
        case .x:
            transforms[index] = (value, y, scaleX, scaleY, rotate)
        case .y:
            transforms[index] = (x, value, scaleX, scaleY, rotate)
        case .scaleX:
            transforms[index] = (x, y, value, scaleY, rotate)
        case .scaleY:
            transforms[index] = (x, y, scaleX, value, rotate)
        case .rotate:
            transforms[index] = (x, y, scaleX, scaleY, value)
        }
    }
    
    func makeAffineTransform(for order: ATApplyOrder) -> CGAffineTransform {
        var transform = CGAffineTransform.identity
        for (x, y, scaleX, scaleY, rotate) in transforms {
            switch order {
            case .bySTR:
                transform = transform.scaledBy(x: scaleX, y: scaleY)
                                    .translatedBy(x: x, y: y)
                                    .rotated(by: rotate)
            case .bySRT:
                transform = transform.scaledBy(x: scaleX, y: scaleY)
                                    .rotated(by: rotate)
                                    .translatedBy(x: x, y: y)
            case .byTSR:
                transform = transform.translatedBy(x: x, y: y)
                                    .scaledBy(x: scaleX, y: scaleY)
                                    .rotated(by: rotate)
            case .byTRS:
                transform = transform.translatedBy(x: x, y: y)
                                    .rotated(by: rotate)
                                    .scaledBy(x: scaleX, y: scaleY)
            case .byRST:
                transform = transform.rotated(by: rotate)
                                    .scaledBy(x: scaleX, y: scaleY)
                                    .translatedBy(x: x, y: y)
            case .byRTS:
                transform = transform.rotated(by: rotate)
                                    .translatedBy(x: x, y: y)
                                    .scaledBy(x: scaleX, y: scaleY)
            }
        }
        return transform
    }
}
