//
//  ResetButton.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ResetButton: SKNode {
     init(height: CGFloat, location: CGPoint) {
        super.init()
        let sprite = SKSpriteNode(imageNamed: "reset");
        
        let resetLabel = SKLabelNode(text: "Reset");
        resetLabel.fontName = Constants.LabelFont
        resetLabel.fontSize = Constants.LabelFontSize
        resetLabel.fontColor = SKColor.blackColor();
        resetLabel.verticalAlignmentMode = .Top

        self.addChild(sprite)
        self.addChild(resetLabel);

        let labelHeight = resetLabel.calculateAccumulatedFrame().height

        // XXX this makes no sense to me but it seems to be needed on ipads to make things line up
        if (UIDevice.currentDevice().userInterfaceIdiom == .Pad) {
            resetLabel.position = CGPoint(x: 0, y: -labelHeight - 20)
        }

        sprite.setScale((height - labelHeight - 5) / sprite.size.height)
        sprite.position = CGPoint(x: 0, y: labelHeight + 5)

        self.position = location
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
