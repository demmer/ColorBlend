//
//  ResetButton.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SpriteKit

class ResetButton: SKNode {
     init(size: CGFloat, location: CGPoint) {
        super.init()
        let sprite = SKSpriteNode(imageNamed: "reset");
        sprite.setScale(60 / sprite.size.height)
        self.addChild(sprite)

        let resetLabel = SKLabelNode(text: "Reset");
        resetLabel.fontSize = 18;
        resetLabel.fontName = Constants.LabelFont
        resetLabel.fontColor = SKColor.blackColor();
        resetLabel.position = CGPoint(x: 0, y: -40);
        self.addChild(resetLabel);
        
        self.position = location
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
