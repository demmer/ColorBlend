//
//  ColorWheel.swift
//  ColorBlend
//
//  Created by Michael Demmer on 6/9/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ColorWheel: SKNode {
    var wheel: SKNode
    var line: SKShapeNode?
    var label: SKLabelNode
    var size: CGFloat
    
    var hue: CGFloat {
        didSet {
            update()
        }
    }

    init(size: CGFloat) {
        self.size = size;

        let wheelSize = 60;
        
        wheel = SKSpriteNode(imageNamed: "color_wheel")

        label = SKLabelNode(text: "50\u{00B0}")

        hue = 0
        
        super.init()
        
        self.addChild(wheel)
        self.addChild(label)

        label.position = CGPoint(x: size * 0.5, y: 0)
        label.fontSize = 12
        label.fontName = Constants.LabelFont
        label.fontColor = SKColor.blackColor()
        label.horizontalAlignmentMode = .Center
        
        let wheelY = CGFloat(label.calculateAccumulatedFrame().height + 35);
        wheel.position = CGPoint(x: size * 0.5, y: wheelY)
        wheel.setScale(CGFloat(wheelSize) / wheel.calculateAccumulatedFrame().width)
        wheel.zRotation = CGFloat(-M_PI * 3/16)

        let frame = self.calculateAccumulatedFrame()
        self.yScale = size / frame.height
        self.xScale = size / frame.height
    }
    
    func update() {
        if (line != nil) {
            line!.removeFromParent()
            line = nil
        }
        
        if (hue != 0) {
            let x = (size / 2) * cos(2 * CGFloat(M_PI) * hue)
            let y = (size / 2) * sin(2 * CGFloat(M_PI) * hue)
            
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

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
