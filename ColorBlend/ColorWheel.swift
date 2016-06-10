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
    var size: CGFloat
    
    var hue: CGFloat {
        didSet {
            update()
        }
    }

    init(size: CGFloat) {
        self.size = size;
        
        wheel = SKSpriteNode(imageNamed: "color_wheel")

        let frame = wheel.calculateAccumulatedFrame()

        wheel.setScale(CGFloat(size) / frame.width)
        
        hue = 0
        
        super.init()
        
        wheel.position = CGPoint(x: size / 2, y: size / 2)
        wheel.zRotation = CGFloat(-M_PI * 3/16)
        
        self.addChild(wheel)
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
