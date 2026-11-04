//
//  Palette.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import UIKit

/// The paints you can drop into a blend.
nonisolated enum Palette {
    static let red = UIColor.red
    static let green = UIColor.green
    static let blue = UIColor.blue
    static let cyan = UIColor.cyan
    static let magenta = UIColor.magenta
    static let yellow = UIColor.yellow
    static let orange = UIColor.orange
    static let brown = UIColor.brown
    static let purple = UIColor.purple
    static let white = UIColor.white
    static let gray = UIColor.lightGray
    static let black = UIColor.black
    static let pink = UIColor(red: 1, green: 0.7529411764705882, blue: 0.796078431372549, alpha: 1)

    /// The palette as laid out on screen: two rows of seven, with the gap in the
    /// first row holding the reset button.
    static let rows: [[UIColor?]] = [
        [red, green, blue, nil, cyan, magenta, yellow],
        [purple, brown, orange, pink, white, gray, black],
    ]
}
