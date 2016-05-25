//
//  IconButton.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class IconButton: SKNode {
    var shape: SKShapeNode;
    var icon: SKLabelNode;
    var label: SKLabelNode;
    
    var active: Bool {
        didSet {
            if (self.active) {
                self.label.fontName = Constants.LabelFontActive
                self.shape.fillColor = SKColor.blackColor()
                self.icon.fontColor = SKColor.whiteColor();
            } else {
                self.label.fontName = Constants.LabelFont
                self.shape.fillColor = SKColor.whiteColor()
                self.icon.fontColor = SKColor.blackColor();
            }
        }
    };

    init(icon: String, label: String, size: CGFloat, location: CGPoint) {
        let box: CGFloat = 50;

        self.active = false;
        
        self.shape = SKShapeNode.init(ellipseOfSize: CGSize(width: 40, height: 40))
        self.shape.strokeColor = SKColor.blackColor();
        self.shape.fillColor = SKColor.whiteColor();
        self.shape.lineWidth = 3 * box / size

        self.icon = SKLabelNode(text: icon)
        self.icon.fontSize = CGFloat(size)
        self.icon.fontName = Constants.LabelFont
        self.icon.fontColor = SKColor.blackColor()
        self.icon.position = CGPoint(x: 0, y: 00)
        self.icon.verticalAlignmentMode = .Center

        self.label = SKLabelNode(text: label)
        self.label.fontSize = 16;
        self.label.fontName = Constants.LabelFont
        self.label.fontColor = SKColor.blackColor()
        self.label.position = CGPoint(x: 0, y: -40)
        self.label.verticalAlignmentMode = .Baseline

        super.init()
        self.position = location
        
        self.addChild(self.shape)
        self.addChild(self.icon)
        self.addChild(self.label)

        self.setScale(size / box)
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}