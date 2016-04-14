//
//  GameScene.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright (c) 2016 Michael Demmer. All rights reserved.
//

import SpriteKit;

class GameScene: SKScene {
    var contentCreated: Bool = false;
    var colors: Set<SKColor> = [];
    
    func addPaletteOval(color: UIColor, row: CGFloat, col: CGFloat) {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);
        let sceneHeight: CGFloat = CGRectGetMaxY(self.frame);

        let width = sceneWidth / 8;
        let height = 1.7 * width;
        let size = CGSize(width: width, height: height);

        let x = col * (sceneWidth / 6.0) - (sceneWidth / 12.0);
        let y = sceneHeight - (row * 1.2 * height) + (height / 2);
        
        let location = CGPoint(x: x, y: y)
        
        let sprite = SKShapeNode.init(ellipseOfSize: size)
        sprite.strokeColor = SKColor.blackColor();
        sprite.fillColor = color;
        sprite.position = location;

        self.addChild(sprite)
    }
    
    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.addPaletteOval(SKColor.redColor(),    row: 1, col: 1);
            self.addPaletteOval(SKColor.blueColor(),   row: 1, col: 2);
            self.addPaletteOval(SKColor.greenColor(),  row: 1, col: 3);
            self.addPaletteOval(SKColor.yellowColor(), row: 1, col: 4);
            self.addPaletteOval(SKColor.whiteColor(),  row: 1, col: 5);
            self.addPaletteOval(SKColor.blackColor(),  row: 1, col: 6);
            self.addPaletteOval(SKColor.purpleColor(), row: 2, col: 1);
            self.addPaletteOval(SKColor.brownColor(),  row: 2, col: 2);
            self.addPaletteOval(SKColor.orangeColor(), row: 2, col: 3);
            self.addPaletteOval(SKColor.grayColor(),   row: 2, col: 4);
            self.addPaletteOval(SKColor.cyanColor(),   row: 2, col: 5);
            self.addPaletteOval(SKColor.init(red:1,green:0.75,blue:0.82,alpha:1), row: 2, col: 6);
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
