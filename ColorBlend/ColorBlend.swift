//
//  GameScene.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright (c) 2016 Michael Demmer. All rights reserved.
//
//
// TODO:
// - Add counts for each color in the palette
// - Rearrange so the controls are on the bottom
// - Add animation when the palette is touched
// - Add Magenta or replace

import SpriteKit;

enum Mode {
    case RGB
    case HSV
};


func printFonts() {
    let fontFamilyNames = UIFont.familyNames()
    for familyName in fontFamilyNames {
        print("------------------------------")
        print("Font Family Name = [\(familyName)]")
        let names = UIFont.fontNamesForFamilyName(familyName)
        print("Font Names = [\(names)]")
    }
}


class GameScene: SKScene {
    var mode: Mode!;
    var contentCreated: Bool = false;
    var colors: Array<SKColor> = [];
    var palette: Set<SKNode> = [];
    var counts: Dictionary<SKColor, SKLabelNode> = [:];
    var canvas: SKShapeNode!;
    var currentColor: SKColor!;
    var touchStart: CGPoint!;
    var dragger: SKShapeNode!;
    var dragColor: SKColor!;
    var resetButton: ResetButton!;
    var colorLabel: SKLabelNode!;
    var redLevel, greenLevel, blueLevel, satLevel, valLevel: ColorLevel!;
    var colorWheel: ColorWheel!;
    var sceneWidth: CGFloat = 0;
    var sceneHeight: CGFloat = 0;
    
    func getPaletteCoords(row row: CGFloat, col: CGFloat) -> (width: CGFloat, height: CGFloat, x: CGFloat, y: CGFloat) {
        let width = sceneWidth / 9;
        let height = 1.3 * width;
        
        let x = col * (sceneWidth / 7.0) - (sceneWidth / 14.0);
        let y = 4 * height - (1.5 * row * height);

        return (width: width, height: height, x: x, y: y)
    }
    
    func addPaletteOval(color: UIColor, row: CGFloat, col: CGFloat) {
        let (width, height, x, y) = getPaletteCoords(row: row, col: col)
        
        let size = CGSize(width: width, height: height);

        let shape = SKShapeNode.init(ellipseOfSize: size)
        shape.strokeColor = SKColor.blackColor();
        shape.fillColor = color;
        shape.position = CGPoint(x: x, y: y);

        self.palette.insert(shape)
        self.addChild(shape)
        
        let label = SKLabelNode(text: "")
        label.position = CGPoint(x: x, y: y - height / 2 - 20)
        label.fontName = Constants.LabelFont
        label.fontSize = 18
        label.verticalAlignmentMode = .Bottom
        label.fontColor = SKColor.blackColor()
        
        counts[shape.fillColor] = label
        
        self.addChild(label)
    }
 
    func addPalette() {
        let pinkColor = SKColor.init(red:1,green:0.75,blue:0.82,alpha:1)
        
        self.addPaletteOval(SKColor.redColor(),    row: 1, col: 1);
        self.addPaletteOval(SKColor.greenColor(),  row: 1, col: 2);
        self.addPaletteOval(SKColor.blueColor(),   row: 1, col: 3);
        self.addPaletteOval(SKColor.cyanColor(),   row: 1, col: 5);
        self.addPaletteOval(SKColor.magentaColor(),row: 1, col: 6);
        self.addPaletteOval(SKColor.yellowColor(), row: 1, col: 7);

        self.addPaletteOval(SKColor.purpleColor(),    row: 2, col: 1);
        self.addPaletteOval(SKColor.brownColor(),     row: 2, col: 2);
        self.addPaletteOval(SKColor.orangeColor(),    row: 2, col: 3);
        self.addPaletteOval(pinkColor,                row: 2, col: 4);
        self.addPaletteOval(SKColor.whiteColor(),     row: 2, col: 5);
        self.addPaletteOval(SKColor.lightGrayColor(), row: 2, col: 6);
        self.addPaletteOval(SKColor.blackColor(),     row: 2, col: 7);
    }

    func addCanvas() {
        let cornerRadius = sceneWidth / 25;
        let path = CGPathCreateWithRoundedRect(CGRect(x: 0, y: 0, width: 0.8 * sceneWidth, height: 0.4 * sceneHeight),
            cornerRadius, cornerRadius, nil)
        canvas = SKShapeNode.init(path: path);
        canvas.position = CGPoint(x: 0.1 * sceneWidth, y: 0.35 * sceneHeight)
        canvas.strokeColor = SKColor.blackColor()
        self.addChild(canvas)
    }
    
    func addControls() {
        let (_, height, x, y) = getPaletteCoords(row: 1, col: 4)
        self.resetButton = ResetButton(size: height, location: CGPoint(x: x, y: y + 5))
        self.addChild(self.resetButton);
    }
    
    func addStatus() {
        let group = SKNode();
        group.position = CGPoint(x: 0, y: sceneHeight * 0.8);
        self.addChild(group)
        
        self.colorLabel = SKLabelNode(text: "");
        let top = sceneHeight * 0.2
        self.colorLabel.position = CGPoint(x: sceneWidth / 2, y: top - 28);
        self.colorLabel.fontSize = 24;
        self.colorLabel.fontName = Constants.LabelFont
        self.colorLabel.fontColor = SKColor.blackColor();
        group.addChild(self.colorLabel);
        
        let levelWidth: CGFloat = sceneWidth * 0.1;
        let levelHeight: CGFloat = levelWidth * 2;
        
        self.redLevel = ColorLevel(color: SKColor.redColor(), width: levelWidth, height: levelHeight);
        self.greenLevel = ColorLevel(color: SKColor.greenColor(), width: levelWidth, height: levelHeight);
        self.blueLevel = ColorLevel(color: SKColor.blueColor(), width: levelWidth, height: levelHeight);
        self.satLevel = ColorLevel(color: SKColor.blackColor(), width: levelWidth, height: levelHeight)
        self.valLevel = ColorLevel(color: SKColor.blackColor(), width: levelWidth, height: levelHeight)
        
        let levelY = self.colorLabel.frame.minY - self.redLevel.calculateAccumulatedFrame().height - 30

        // 5-15 red
        // 15-25 green
        // 25-35 blue
        self.redLevel.position = CGPoint(x: sceneWidth * 0.05, y: levelY)
        group.addChild(redLevel)
        
        self.greenLevel.position = CGPoint(x: sceneWidth * 0.15, y: levelY)
        group.addChild(greenLevel)
        
        self.blueLevel.position = CGPoint(x: sceneWidth * 0.25, y: levelY)
        group.addChild(blueLevel)
        
        // 40-60 wheel
        colorWheel = ColorWheel(size: sceneWidth * 0.2)
        colorWheel.position = CGPoint(x: sceneWidth * 0.4, y: levelY)
        group.addChild(colorWheel)

        // 75-85 sat
        // 85-95 val
        self.satLevel.position = CGPoint(x: sceneWidth * 0.75, y: levelY)
        group.addChild(satLevel)
        
        self.valLevel.position = CGPoint(x: sceneWidth * 0.85, y: levelY)
        group.addChild(valLevel)
        
        self.updateStatus();
    }
    
    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            sceneWidth = CGRectGetMaxX(self.frame);
            sceneHeight = CGRectGetMaxY(self.frame);

            self.addPalette();
            self.addCanvas();
            self.addControls();
            self.addStatus();
            
            self.mode = .HSV
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
        touchStart = touch!.locationInNode(self)
    }

    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!;

        if (self.dragger != nil) {
            self.dragger.position = touch.locationInNode(self);

        } else {
            // Check if the dragging started at a palette node -- if so create a new dragger.
            let node = self.nodeAtPoint(touchStart)
            if (self.palette.contains(node)) {
                self.dragger = node.copy() as! SKShapeNode;
                self.dragColor = (node as! SKShapeNode).fillColor
                self.addChild(self.dragger);
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first!;
        let location = touch.locationInNode(self);

        if (self.resetButton.containsPoint(touchStart) && self.resetButton.containsPoint(location)) {
            self.reset();
        }

        else if (self.dragger != nil) {
            if (canvas.containsPoint(location)) {
                self.addColor(dragColor)
            }
            self.removeDragger()
        } else {
            // Handle touches inside the palette
            let startNode = self.nodeAtPoint(touchStart)
            let endNode = self.nodeAtPoint(touch.locationInNode(self))
            if (startNode == endNode && self.palette.contains(startNode)) {
                let mover = startNode.copy() as! SKShapeNode;
                self.addChild(mover)
                mover.runAction(SKAction.moveTo(CGPoint(x: sceneWidth / 2, y: sceneHeight / 2), duration: 0.25),
                                completion: {
                                    self.addColor(mover.fillColor);
                                    mover.removeFromParent()
                                }
                );
                
            }
        }
    }
    
    func addColor(color: SKColor) {
        colors.append(color)
        
        let countLabel = counts[color]!
        var count = Int(countLabel.text!)
        if (count == nil) {
            count = 1
        } else {
            count = count! + 1
        }
        countLabel.text = String(count!)
        
        updateCanvas();
    }
    
    func reset() {
        self.colors.removeAll();
        self.currentColor = nil;
        self.updateStatus();
        self.canvas.fillColor = SKColor.whiteColor()
        
        for (_, label) in counts {
            label.text = ""
        }
    }
    
    func updateCanvas() {
        if (self.mode == .RGB) {
            self.currentColor = ColorUtils.rgbBlend(self.colors)
        } else {
            self.currentColor = ColorUtils.hsvBlend(self.colors)
        }
        self.updateStatus();
        self.canvas.fillColor = self.currentColor;
    }

    func updateStatus() {
        var red: CGFloat = 0.0;
        var green: CGFloat = 0.0;
        var blue: CGFloat = 0.0;

        var hue: CGFloat = 0.0;
        var sat: CGFloat = 0.0;
        var val: CGFloat = 0.0;
        
        if (self.currentColor != nil) {
            self.currentColor.getRed(&red, green: &green, blue: &blue, alpha: nil);
            self.currentColor.getHue(&hue, saturation: &sat, brightness: &val, alpha: nil)
            self.colorLabel.text = ColorName.closestMatch(self.currentColor)
        } else {
            self.colorLabel.text = "(Touch Colors To Blend)";
        }
        
        self.redLevel.level = red;
        self.greenLevel.level = green;
        self.blueLevel.level = blue;
        self.satLevel.level = sat;
        self.valLevel.level = val;
        
        self.colorWheel.hue = hue;
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
