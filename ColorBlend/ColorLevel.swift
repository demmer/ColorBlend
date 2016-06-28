//
//  ColorLevel.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/28/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ColorLevel: SKNode {
    var title: SKLabelNode;
    var levelLabel: SKLabelNode;
    var outline: SKShapeNode;
    var fill: SKShapeNode!;
    var color: SKColor {
        didSet {
            outline.strokeColor = color
            fill.strokeColor = color
            fill.fillColor = color
        }
    }
    let barWidth: Int;
    let barHeight: Int;
    let margin = 5;
    var barY: Int;
    var level: CGFloat;
    
    init(title titleString: String, color: SKColor, width: CGFloat, height: CGFloat) {
        self.color = color;
        self.barWidth = Int(width);

        levelLabel = SKLabelNode(text: "0%")
        levelLabel.fontColor = SKColor.blackColor()
        levelLabel.fontName = Constants.LabelFont
        levelLabel.fontSize = Constants.LabelFontSize
        levelLabel.horizontalAlignmentMode = .Left
        
        title = SKLabelNode(text: titleString)
        title.fontColor = SKColor.blackColor()
        title.fontName = Constants.LabelFont
        title.fontSize = Constants.LabelFontSize
        title.horizontalAlignmentMode = .Left

        let labelHeight = Int(self.levelLabel.calculateAccumulatedFrame().height)

        barHeight = Int(height) - 2*labelHeight - 2*margin;

        barY = labelHeight + margin

        outline = SKShapeNode(rect: CGRect(x: 0, y: barY, width: barWidth, height: barHeight))
        outline.strokeColor = color;

        level = 1

        super.init()
        
        title.position = CGPoint(x: self.centerX(title), y: barY + barHeight + 5)
        levelLabel.position = CGPoint(x: 0, y: 0)
        
        self.addChild(self.levelLabel);
        self.addChild(self.outline);
        self.addChild(self.title);
        self.update(1)
    }
    
    func centerX(node: SKNode) -> Int {
        return -(Int(node.calculateAccumulatedFrame().width) - barWidth) / 2
    }

    func update(level: CGFloat) {
        self.level = level
        
        if (fill != nil) {
            fill.removeFromParent()
        }

        fill = SKShapeNode(rect: CGRect(x: 0, y: barY, width: barWidth, height: Int(CGFloat(barHeight) * level)))
        fill.strokeColor = color;
        fill.fillColor = color;
        
        self.addChild(fill)
        
        levelLabel.text = "\(Int(self.level * 100))%"
        levelLabel.position = CGPoint(x: centerX(levelLabel), y: 0);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
