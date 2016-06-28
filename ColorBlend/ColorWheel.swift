//
//  ColorWheel.swift
//  ColorBlend
//
//  Created by Michael Demmer on 6/9/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ColorWheel: SKNode {
    var title, level: SKLabelNode;
    var wheel: SKNode
    var line: SKShapeNode?
    var size: CGFloat
    var wheelSize: CGFloat
    
    var hue: CGFloat {
        didSet {
            update()
        }
    }

    init(size: CGFloat) {
        self.size = size;
        
        
        title = SKLabelNode(text: "Hue")
        title.fontColor = SKColor.blackColor()
        title.fontName = Constants.LabelFont
        title.fontSize = Constants.LabelFontSize
        title.horizontalAlignmentMode = .Left
        
        let labelHeight = title.frame.height;

        wheelSize = size - labelHeight - 20

        wheel = SKSpriteNode(imageNamed: "color_wheel")
        wheel.setScale(CGFloat(wheelSize) / wheel.frame.width)
        
        level = SKLabelNode(text: "")
        level.fontColor = SKColor.blackColor()
        level.fontName = Constants.LabelFont
        level.fontSize = Constants.LabelFontSize
        level.horizontalAlignmentMode = .Left
        
        hue = 0
        
        super.init()

        title.position = CGPoint(x: size / 2 - title.frame.width / 2, y: size - labelHeight);
        
        wheel.position = CGPoint(x: size / 2, y: size / 2)
        wheel.zRotation = CGFloat(-M_PI * 3/16)
        
        level.position = CGPoint(x: size / 2 - level.frame.width / 2, y: 0)
        
        self.addChild(title)
        self.addChild(wheel)
        self.addChild(level)
    }
    
    func update() {
        if (line != nil) {
            line!.removeFromParent()
            line = nil
        }
        
        if (hue != 0) {
            let x = (wheelSize / 2) * cos(2 * CGFloat(M_PI) * hue)
            let y = (wheelSize / 2) * sin(2 * CGFloat(M_PI) * hue)
            
            let path = CGPathCreateMutable()
            CGPathMoveToPoint(path, nil, 0, 0)
            CGPathAddLineToPoint(path, nil, x, y)
            line = SKShapeNode(path: path)
            line!.strokeColor = SKColor.blackColor()
            line!.lineWidth = 2
            line!.zPosition = 2
            line!.position = CGPoint(x: size / 2, y: size / 2)
            self.addChild(line!)
        }
        
        level.text = "\(Int(hue * 360))\u{00B0}"
        level.position = CGPoint(x: size / 2 - level.frame.width / 2, y: 0)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
