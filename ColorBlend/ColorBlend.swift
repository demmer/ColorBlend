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
    case Additive
    case Subtractive
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
    var canvas: SKShapeNode!;
    var currentColor: SKColor!;
    var dragger: SKShapeNode!;
    var resetButton: ResetButton!;
    var colorLabel, countLabel, blendLabel, hsvLabel: SKLabelNode!;
    var additiveMode, subtractiveMode: IconButton!;
    
    func addPaletteOval(color: UIColor, row: CGFloat, col: CGFloat) {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);

        let width = sceneWidth / 9;
        let height = 1.3 * width;
        let size = CGSize(width: width, height: height);

        let x = col * (sceneWidth / 7.0) - (sceneWidth / 14.0);
        let y = 4 * height - (1.5 * row * height);
        
        let shape = SKShapeNode.init(ellipseOfSize: size)
        shape.strokeColor = SKColor.blackColor();
        shape.fillColor = color;
        shape.position = CGPoint(x: x, y: y);

        self.palette.insert(shape)
        self.addChild(shape)
        
        let label = SKLabelNode(text: "")
        label.position = CGPoint(x: x, y: y - height / 2 - 18)
        label.fontName = Constants.LabelFont
        label.fontSize = 16
        label.verticalAlignmentMode = .Bottom
        label.fontColor = SKColor.blackColor()
        self.addChild(label)
    }
 
    func addPalette() {
        let pinkColor = SKColor.init(red:1,green:0.75,blue:0.82,alpha:1)
        
        self.addPaletteOval(SKColor.redColor(),    row: 1, col: 1);
        self.addPaletteOval(SKColor.greenColor(),  row: 1, col: 2);
        self.addPaletteOval(SKColor.blueColor(),   row: 1, col: 3);
        self.addPaletteOval(SKColor.cyanColor(),   row: 1, col: 4);
        self.addPaletteOval(SKColor.magentaColor(),row: 1, col: 5);
        self.addPaletteOval(SKColor.yellowColor(), row: 1, col: 6);
        self.addPaletteOval(SKColor.whiteColor(),  row: 1, col: 7);

        self.addPaletteOval(SKColor.purpleColor(),    row: 2, col: 1);
        self.addPaletteOval(SKColor.brownColor(),     row: 2, col: 2);
        self.addPaletteOval(SKColor.orangeColor(),    row: 2, col: 3);
        self.addPaletteOval(pinkColor,                row: 2, col: 4);
        self.addPaletteOval(SKColor.darkGrayColor(),  row: 2, col: 5);
        self.addPaletteOval(SKColor.lightGrayColor(), row: 2, col: 6);
        self.addPaletteOval(SKColor.blackColor(),     row: 2, col: 7);
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

        var group = SKNode();
        self.additiveMode = IconButton(icon: "+", label: "Additive",
                                       size: 50, location: CGPoint(x: sceneWidth * 0.15, y: sceneHeight - 75))
        self.addChild(self.additiveMode)

        self.subtractiveMode = IconButton(icon: "HSV", label: "Subtractive",
                                          size: 50, location: CGPoint(x: sceneWidth * 0.4, y: sceneHeight - 75))
        self.addChild(self.subtractiveMode)

        self.resetButton = ResetButton(size: 50, location: CGPoint(x: sceneWidth * 0.75, y: sceneHeight - 75))
        self.addChild(self.resetButton);
        
    }
    
    func addStatus() {
        let sceneWidth: CGFloat = CGRectGetMaxX(self.frame);
        let sceneHeight: CGFloat = CGRectGetMaxY(self.frame);

        self.colorLabel = SKLabelNode(text: "None");
        self.colorLabel.position = CGPoint(x: sceneWidth / 2, y: sceneHeight * 0.95);
        self.colorLabel.fontSize = 18;
        self.colorLabel.fontName = "HelveticaNeue"
        self.colorLabel.fontColor = SKColor.blackColor();
        self.addChild(self.colorLabel);

        self.countLabel = SKLabelNode(text: "Mixing");
        self.countLabel.position = CGPoint(x: sceneWidth / 2, y: sceneHeight * 0.75);
        self.countLabel.fontSize = 16;
        self.countLabel.fontName = "HelveticaNeue"
        self.countLabel.fontColor = SKColor.blackColor();
        self.addChild(self.countLabel);

        self.blendLabel = SKLabelNode(text: "Red Green Blue");
        self.blendLabel.position = CGPoint(x: sceneWidth / 2, y: sceneHeight * 0.75 - self.countLabel.frame.height);
        self.blendLabel.fontSize = 16;
        self.blendLabel.fontName = "HelveticaNeue"
        self.blendLabel.fontColor = SKColor.blackColor();
        self.addChild(self.blendLabel);

        self.hsvLabel = SKLabelNode(text: "Hue Sat Val");
        self.hsvLabel.position = CGPoint(x: sceneWidth / 2, y: sceneHeight * 0.75 - self.countLabel.frame.height * 2);
        self.hsvLabel.fontSize = 16;
        self.hsvLabel.fontName = "HelveticaNeue"
        self.hsvLabel.fontColor = SKColor.blackColor();
        self.addChild(self.hsvLabel);
        
        self.updateStatus();
    }
    
    override func didMoveToView(view: SKView) {
        if (!self.contentCreated) {
            self.addPalette();
            self.addCanvas();
            self.addControls();
            self.addStatus();
            
            self.mode = .Additive
            self.additiveMode.active = true
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
        
        if (self.additiveMode.containsPoint(location)) {
            self.mode = .Additive;
            self.additiveMode.active = true;
            self.subtractiveMode.active = false;
            self.updateCanvas()

        } else if (self.subtractiveMode.containsPoint(location)) {
            self.mode = .Subtractive
            self.additiveMode.active = false;
            self.subtractiveMode.active = true;
            self.updateCanvas()

        } else if (self.resetButton.containsPoint(location)) {
            self.reset();

        } else if (self.palette.contains(node)) {
            self.removeDragger();
            self.dragger = node.copy() as! SKShapeNode;
            self.addChild(self.dragger);
        }
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
        self.currentColor = nil;
        self.updateStatus();
        self.canvas.fillColor = SKColor.whiteColor()
    }
    
    func updateCanvas() {
        if (self.mode == .Additive) {
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
            self.colorLabel.text = "";
        }
        
        self.countLabel.text = "Mixed \(self.colors.count) color(s):";
        self.blendLabel.text = "Red \(Int(red*100))% Green \(Int(green*100))% Blue \(Int(blue*100))%";
        self.hsvLabel.text = "Hue \(Int(hue*100)) Sat \(Int(sat*100))% Brightness \(Int(val*100))%";
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
