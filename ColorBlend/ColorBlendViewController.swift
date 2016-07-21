//
//  GameViewController.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright (c) 2016 Michael Demmer. All rights reserved.
//

import UIKit
import SpriteKit

class ColorBlendViewController: UIViewController {
    var currentGame: ColorBlendScene!
    
    @IBAction func colorSelectionComplete(sender: UIStoryboardSegue) {
        let table = sender.sourceViewController as! ColorTableViewController
        if (sender.identifier == "ColorSelectionSegue") {
            currentGame.reset()
            currentGame.showBlend(colorName: table.selectedColor!)
        } else if (sender.identifier == "CancelColorSelectionSegue") {
            // no-op
        } else if (sender.identifier == "RandomColorSelectionSegue") {
            let i = arc4random_uniform(UInt32(ColorName.ColorNames.count))
            currentGame.showBlend(colorName: ColorName.ColorNames[Int(i)].name)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = ColorBlendScene(fileNamed:"ColorBlend") {
            currentGame = scene
            scene.viewController = self
            
            // Configure the view.
            let skView = self.view as! SKView
            scene.backgroundColor = SKColor.whiteColor()

            skView.ignoresSiblingOrder = true
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
