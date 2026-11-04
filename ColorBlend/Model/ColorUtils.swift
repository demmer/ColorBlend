//
//  ColorUtils.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import UIKit

nonisolated extension UIColor {
    var rgb: (red: CGFloat, green: CGFloat, blue: CGFloat) {
        var r: CGFloat = 0, g: CGFloat = 0, b: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: nil)
        return (r, g, b)
    }

    /// Hue, saturation and brightness. A hue of 0 always means "no hue" (a white,
    /// gray or black); pure reds report 1.0 instead, as UIKit did back on iOS 9.
    /// The blend math depends on that distinction.
    var hsb: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
        var h: CGFloat = 0, s: CGFloat = 0, v: CGFloat = 0
        getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        if h == 0 && s > 0 {
            h = 1
        }
        return (h, s, v)
    }
}

nonisolated enum ColorUtils {
    static func hsvBlend(_ colors: [UIColor]) -> UIColor {
        if colors.isEmpty {
            return .white
        }

        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var val: CGFloat = 0

        var x: CGFloat = 0
        var y: CGFloat = 0

        let pi2: CGFloat = 3.14159 * 2

        var hues: CGFloat = 0
        var whites: CGFloat = 0

        for color in colors {
            let (h, s, v) = color.hsb

            if h != 0 {
                hues += 1
                x += cos(pi2 * h)
                y += sin(pi2 * h)
                sat += s
            } else if v == 1.0 {
                whites += 1
            }

            val += v
        }

        sat = sat / (hues + whites)
        val = val / CGFloat(colors.count)

        if x != 0.0 || y != 0.0 {
            hue = atan2(y, x)
            while hue < 0 {
                hue += pi2
            }
            hue = hue / pi2
        } else {
            sat = 0
        }

        return UIColor(hue: hue, saturation: sat, brightness: val, alpha: 1.0)
    }

    static func getHueDegrees(_ color: UIColor) -> Int {
        Int(round(color.hsb.hue * 360))
    }

    static let primaryHues: [Int: UIColor] = [
        0: Palette.red,
        30: Palette.yellow,
        60: Palette.yellow,
        90: Palette.green,
        120: Palette.green,
        150: Palette.cyan,
        180: Palette.cyan,
        210: Palette.blue,
        240: Palette.blue,
        270: Palette.magenta,
        300: Palette.magenta,
        330: Palette.red,
        360: Palette.red,
    ]

    // Figure out the nearest primary color based on the hue of the given color.
    // Use a simple static map by rounding the hue to the nearest 30 degrees
    static func closestPrimaryColor(_ color: UIColor) -> UIColor {
        let hue = getHueDegrees(color)
        let primaryHue = (hue / 30) * 30
        return primaryHues[primaryHue]!
    }

    // Figure out the blend of primary hues based on the delta
    static let hueBlends: [Int: (Int, Int)] = [
        0: (1, 0),
        1: (30, 1),
        2: (20, 1),
        3: (15, 1),
        4: (10, 1),
        5: (8, 1),
        6: (7, 1),
        7: (6, 1),
        8: (5, 1),
        9: (9, 2),
        10: (4, 1),
        11: (11, 3),
        12: (7, 2),
        13: (3, 1),
        14: (11, 4),
        15: (14, 5),
        16: (8, 3),
        17: (9, 4),
        18: (21, 10),
        19: (2, 1),
        20: (2, 1),
        21: (7, 4),
        22: (8, 5),
        23: (3, 2),
        24: (7, 5),
        25: (12, 9),
        26: (5, 4),
        27: (7, 6),
        28: (9, 8),
        29: (1, 1),
        30: (1, 1),

        42: (4, 9),
        43: (2, 5),
        46: (1, 3),
        50: (2, 9),
        52: (1, 6),
        56: (1, 14),
        57: (1, 20),
        58: (1, 30),
    ]

    // Given a color, return the blend of primary colors that will produce the blend
    static func hsvUnblend(_ color: UIColor) -> [UIColor] {
        let (hueX, sat, val) = color.hsb
        let hue = getHueDegrees(color)

        var colors: [UIColor] = []

        // Special case the shades of white / gray / black
        if hueX == 0 || val < 0.001 {
            if val == 1.0 {
                return [Palette.white]
            }

            for _ in 1...100 {
                let v = hsvBlend(colors).hsb.brightness
                if abs(v - val) < 0.01 {
                    return colors
                } else if v < val {
                    colors.append(Palette.white)
                } else {
                    colors.append(Palette.black)
                }
            }

            return colors
        }

        let lowerHue = (hue / 60) * 60
        let upperHue = ((hue + 59) / 60) * 60
        let lower = primaryHues[lowerHue]!
        let upper = primaryHues[upperHue]!

        let delta = abs(hue - lowerHue)
        let lowerCount: Int
        let upperCount: Int
        if delta <= 30 || hueBlends[delta] != nil {
            (lowerCount, upperCount) = hueBlends[delta]!
        } else {
            (upperCount, lowerCount) = hueBlends[60 - delta]!
        }

        colors += Array(repeating: lower, count: lowerCount)
        colors += Array(repeating: upper, count: upperCount)

        let hueColors = colors

        // Next, add some white to drop down the saturation as needed
        func addWhite() {
            for _ in 1...500 {
                let s = hsvBlend(colors).hsb.saturation

                if abs(s - sat) <= 0.005 {
                    break
                }

                if s > sat {
                    colors.append(Palette.white)
                } else {
                    colors += hueColors
                }
            }
        }
        addWhite()

        // Finally, add some black to drop down the value as needed
        for _ in 1...500 {
            let v = hsvBlend(colors).hsb.brightness

            if abs(v - val) <= 0.005 {
                break
            }

            if v > val {
                colors.append(Palette.black)
            } else {
                colors += hueColors
                addWhite()
            }
        }

        return colors
    }
}
