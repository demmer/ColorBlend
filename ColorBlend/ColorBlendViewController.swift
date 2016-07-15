//
//  GameViewController.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright (c) 2016 Michael Demmer. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {
    var currentGame: GameScene!
    
    @IBAction func colorSelectionComplete(sender: UIStoryboardSegue) {
        let table = sender.sourceViewController as! ColorTableViewController
        print("selected color \(table.selectedColor)")
        currentGame.reset()
        currentGame.showBlend(table.selectedColor!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene(fileNamed:"ColorBlend") {
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
