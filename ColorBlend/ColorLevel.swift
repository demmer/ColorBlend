//
//  ColorLevel.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/28/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ColorLevel: SKNode {
    var levelLabel: SKLabelNode;
    var outline: SKShapeNode;
    var fill: SKShapeNode!;
    var color: SKColor;
    let barWidth = 20;
    let barHeight = 50;
    var barY: Int;

    var level: CGFloat {
        didSet {
            self.update();
        }
    }
    
    init(color: SKColor, width: CGFloat, height: CGFloat) {
        self.color = color;
        
        levelLabel = SKLabelNode(text: "0%")
        levelLabel.fontColor = SKColor.blackColor()
        levelLabel.fontName = Constants.LabelFont
        levelLabel.fontSize = 12
        levelLabel.position = CGPoint(x: 0, y: 0)
        levelLabel.horizontalAlignmentMode = .Left
        
        barY = Int(self.levelLabel.calculateAccumulatedFrame().height + 5);
        outline = SKShapeNode(rect: CGRect(x: 0, y: barY, width: barWidth, height: barHeight))
        outline.strokeColor = color;

        level = 1
        
        super.init()

        self.addChild(self.levelLabel);
        self.addChild(self.outline);
        self.update()
        
        let frame = self.calculateAccumulatedFrame()
        self.yScale = height / frame.height
        self.xScale = width / frame.width
    }

    func update() {
        if (fill != nil) {
            fill.removeFromParent()
        }

        fill = SKShapeNode(rect: CGRect(x: 0, y: barY, width: barWidth, height: Int(CGFloat(barHeight) * level)))
        fill.strokeColor = color;
        fill.fillColor = color;
        
        self.addChild(fill)
        
        levelLabel.text = "\(Int(self.level * 100))%"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
