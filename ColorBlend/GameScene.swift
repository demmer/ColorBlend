//
//  GameScene.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright (c) 2016 Michael Demmer. All rights reserved.
//

import SpriteKit;

struct PaletteDimensions {
    static var width = 50
    static var height = 90
    static var padding = 10
}

class GameScene: SKScene {
    var contentCreated: Bool = false;
    
    func addPaletteColor(color: UIColor, row: Int, col: Int) {
        let xBase = Int(CGRectGetMinX(self.frame));
        let yBase = Int(CGRectGetMinY(self.frame));
        
        let location = CGPoint(x: xBase + (col * (PaletteDimensions.width + PaletteDimensions.padding)),
            y: yBase + (row * (PaletteDimensions.height + PaletteDimensions.padding)));
        let size = CGSize(width: PaletteDimensions.width, height: PaletteDimensions.height);
        
        let sprite = SKShapeNode.init(ellipseOfSize: size)
        sprite.strokeColor = color;
        sprite.fillColor = color;
        sprite.position = location;

        self.addChild(sprite)
    }
    
    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.backgroundColor = SKColor.whiteColor();
            self.addPaletteColor(UIColor.init(red: 0.5, green: 0, blue: 0, alpha: 1), row: 1, col: 1);
        }
        self.contentCreated = true;
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
       /* Called when a touch begins */
        
        for touch in touches {
            let location = touch.locationInNode(self)
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
