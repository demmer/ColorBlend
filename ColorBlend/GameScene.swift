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
    var colors: Array<SKColor> = [];
    var palette: Set<SKNode> = [];
    var canvas: SKShapeNode!;
    var currentColor: SKColor = SKColor.whiteColor();
    var dragger: SKShapeNode!;
    var resetButton: SKSpriteNode!;
    var statusLabel: SKLabelNode!;
    
    func addPaletteOval(color: UIColor, row: CGFloat, col: CGFloat) {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);

        let width = sceneWidth / 8;
        let height = 1.5 * width;
        let size = CGSize(width: width, height: height);

        let x = col * (sceneWidth / 6.0) - (sceneWidth / 12.0);
        let y = height * 2.5 - (row * 1.2 * height) + (height / 2);
        
        let location = CGPoint(x: x, y: y)
        
        let shape = SKShapeNode.init(ellipseOfSize: size)
        shape.strokeColor = SKColor.blackColor();
        shape.fillColor = color;
        shape.position = location;

        self.palette.insert(shape)
        self.addChild(shape)
    }
 
    func addPalette() {
        self.addPaletteOval(SKColor.redColor(),    row: 1, col: 1);
        self.addPaletteOval(SKColor.greenColor(),  row: 1, col: 2);
        self.addPaletteOval(SKColor.blueColor(),   row: 1, col: 3);
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

    func addCanvas() {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);
        let sceneHeight: CGFloat = CGRectGetMaxY(self.frame);

        let cornerRadius = sceneWidth / 25;
        let path = CGPathCreateWithRoundedRect(CGRect(x: 0, y: 0, width: 0.8 * sceneWidth, height: 0.4 * sceneHeight),
            cornerRadius, cornerRadius, nil)
        canvas = SKShapeNode.init(path: path);
        canvas.position = CGPoint(x: 0.1 * sceneWidth, y: 0.3 * sceneHeight)
        canvas.strokeColor = SKColor.blackColor()
        self.addChild(canvas)
    }
    
    func addControls() {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);
        let sceneHeight: CGFloat = CGRectGetMaxY(self.frame);
        
        let title = SKLabelNode(text: "Color Blend");
        title.position = CGPoint(x: sceneWidth / 2, y: sceneHeight - 50);
        title.fontSize = 36;
        title.fontColor = SKColor.blackColor();
        self.addChild(title);

        let status = SKLabelNode(text: self.getStatusText());
        status.position = CGPoint(x: sceneWidth / 2, y: sceneHeight * 0.75);
        status.fontSize = 16;
        status.fontColor = SKColor.blackColor();
        self.addChild(status);
        self.statusLabel = status;
        
        self.resetButton = SKSpriteNode(imageNamed: "reset");
        self.resetButton.position = CGPoint(x: sceneWidth * 0.9, y: sceneHeight * 0.8);
        self.resetButton.setScale(0.2);
        self.addChild(self.resetButton);
    }
    
    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.addPalette();
            self.addCanvas();
            self.addControls();
        }
        self.contentCreated = true;
    }

    func removeDragger() {
        if (self.dragger != nil) {
            self.dragger.removeFromParent()
            self.dragger = nil;
        }
    }

    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first;
        let location = touch!.locationInNode(self)
        let node = self.nodeAtPoint(location)

        if (node == self.resetButton) {
            self.reset();
            return;
        }
        
        if (!self.palette.contains(node)) {
            return
        }

        self.removeDragger();
        
        self.dragger = node.copy() as! SKShapeNode;
        self.addChild(self.dragger);
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {self
        if (self.dragger != nil) {
            self.dragger.position = touches.first!.locationInNode(self);
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        if (self.dragger != nil) {
            let location = touches.first!.locationInNode(self);
            let node: SKShapeNode! = self.nodeAtPoint(location) as! SKShapeNode;
            if (node != nil && (self.canvas == node || node.fillColor == dragger.fillColor)) {
                self.colors.append(self.dragger.fillColor)
                self.updateCanvas();
            }
            self.removeDragger()
        }
    }
    
    func reset() {
        self.colors.removeAll();
        self.currentColor = SKColor.whiteColor()
        self.statusLabel.text = self.getStatusText();
        self.canvas.fillColor = self.currentColor
    }
    
    func updateCanvas() {
        var newRed: CGFloat = 0;
        var newGreen: CGFloat = 0;
        var newBlue: CGFloat = 0;
        
        for color in self.colors {
            var red: CGFloat = 0.0;
            var green: CGFloat = 0.0;
            var blue: CGFloat = 0.0;
            
            color.getRed(&red, green: &green, blue: &blue, alpha: nil);
            
            newRed += red;
            newGreen += green;
            newBlue += blue;
        }
        
        newRed = newRed / CGFloat(self.colors.count);
        newGreen = newGreen / CGFloat(self.colors.count);
        newBlue = newBlue / CGFloat(self.colors.count);
        
        self.currentColor = SKColor.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0);
        self.statusLabel.text = self.getStatusText();
        self.canvas.fillColor = self.currentColor;
    }

    func getStatusText() -> String {
        var red: CGFloat = 0.0;
        var green: CGFloat = 0.0;
        var blue: CGFloat = 0.0;
        
        self.currentColor.getRed(&red, green: &green, blue: &blue, alpha: nil);

        return "Blending \(self.colors.count) color(s) to RGB \(Int(red*255)) \(Int(green*255)) \(Int(blue*255))";
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
