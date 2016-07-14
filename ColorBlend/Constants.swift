//
//  Constants.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import UIKit
import SpriteKit

struct Constants {
    static let LabelFont = "Thonburi"
    static let LabelFontActive = "Thonburi-Bold"
    static let LabelFontSize: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 11 : 24;
    static let TitleFontSize: CGFloat = UIDevice.currentDevice().userInterfaceIdiom == .Phone ? 24 : 36;

    struct Palette {
        static let red = SKColor.redColor();
        static let green = SKColor.greenColor()
        static let blue = SKColor.blueColor();
        static let cyan = SKColor.cyanColor();
        static let magenta = SKColor.magentaColor();
        static let yellow = SKColor.yellowColor();
        static let orange = SKColor.orangeColor();
        static let brown = SKColor.brownColor();
        static let purple = SKColor.purpleColor();
        static let white = SKColor.whiteColor();
        static let gray = SKColor.lightGrayColor();
        static let black = SKColor.blackColor();

        static let pink = SKColor.init(red: 1, green: 0.7529411764705882, blue: 0.796078431372549, alpha:1)
    }

}
