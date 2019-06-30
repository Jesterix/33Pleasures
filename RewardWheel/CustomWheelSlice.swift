//
//  CustomWheelSlice.swift
//  RewardWheel
//
//  Created by Georgy Khaydenko on 30/06/2019.
//  Copyright © 2019 Georgy Khaydenko. All rights reserved.
//

import Foundation
import UIKit
import TTFortuneWheel

//Just a basic implementation of spinning wheel slice
public class CustomWheelSlice: FortuneWheelSliceProtocol {
    
    public enum Style {
        case firstColor
        case secondColor
        case thirdColor
        case fourthColor
    }
    
    public var title: String
    public var degree: CGFloat = 0.0
    
    public var backgroundColor: UIColor? {
        switch style {
        case .firstColor: return TTUtils.uiColor(from: 0xFA3E54)//6E17B3//FA3E54
        case .secondColor: return TTUtils.uiColor(from: 0xFF8940)
        case .thirdColor: return TTUtils.uiColor(from: 0x34D2AF)
        case .fourthColor: return TTUtils.uiColor(from: 0x5FEB3B)
        }
    }
    
    public var fontColor: UIColor {
        switch style {
        case .firstColor: return UIColor.black//TTUtils.uiColor(from: 0x00AA72)
        case .secondColor: return UIColor.black//TTUtils.uiColor(from: 0x3BDA00)
        case .thirdColor: return UIColor.black//TTUtils.uiColor(from: 0xF10026)
        case .fourthColor: return UIColor.black//TTUtils.uiColor(from: 0xFF5600)
        }
    }
    
    public var font: UIFont {
        return UIFont.systemFont(ofSize: fontSize, weight: .bold)
    }
    
    public var style:Style = .firstColor
    
    public init(title:String) {
        self.title = title
    }
    
    public convenience init(title:String, degree:CGFloat) {
        self.init(title:title)
        self.degree = degree
    }
    
    public func drawAdditionalGraphics(in context:CGContext, circularSegmentHeight:CGFloat,radius:CGFloat,sliceDegree:CGFloat) {
        let image = UIImage(named: "niddleImage", in: Bundle.sw_frameworkBundle(), compatibleWith: nil)!
        let centerOffset = CGPoint(x: -50, y: -5)
//        let centerOffset = CGPoint(x: -64, y: 17)//original niddle offset
        let additionalGraphicRect = CGRect(x: centerOffset.x, y: centerOffset.y, width: 12, height: 12)
        let additionalGraphicPath = UIBezierPath(rect: additionalGraphicRect)
        context.saveGState()
        additionalGraphicPath.addClip()
        context.scaleBy(x: 1, y: -1)
        context.draw(image.cgImage!, in: CGRect(x: additionalGraphicRect.minX, y: -additionalGraphicRect.minY, width: image.size.width, height: image.size.height), byTiling: true)
        context.restoreGState()
    }
}
