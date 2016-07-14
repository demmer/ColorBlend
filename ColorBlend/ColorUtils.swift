//
//  ColorUtils.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import UIKit

class ColorUtils {
    static func rgbBlend(colors: [UIColor]) -> UIColor {
        var red: CGFloat = 0;
        var green: CGFloat = 0;
        var blue: CGFloat = 0;
        
        if (colors.count > 0) {
            for color in colors {
                var r: CGFloat = 0;
                var g: CGFloat = 0;
                var b: CGFloat = 0;
                color.getRed(&r, green: &g, blue: &b, alpha: nil);
                
                red += r;
                green += g;
                blue += b;
            }
            
            red = red / CGFloat(colors.count)
            green = green / CGFloat(colors.count)
            blue = blue / CGFloat(colors.count)
        }

        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func rgbToCmyk(red red: CGFloat, green: CGFloat, blue: CGFloat) -> (cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat) {
            
        let black = min(1-red, min(1-green, 1-blue));
        var cyan, magenta, yellow: CGFloat;
        if (black < 1) {
            cyan = (1-red-black)/(1-black);
            magenta = (1-green-black)/(1-black);
            yellow = (1-blue-black)/(1-black);
        }
        else {
            cyan = 0;
            magenta = 0;
            yellow = 0;
        }

        return (cyan: cyan, magenta: magenta, yellow: yellow, black: black)
    }
    
    static func cmykToRgb(cyan cyan: CGFloat, magenta: CGFloat, yellow: CGFloat, black: CGFloat) -> (red: CGFloat, green: CGFloat, blue: CGFloat) {
        
        let red = (1-black)-(1-black)*cyan;
        let green = (1-black)-(1-black)*magenta;
        let blue = (1-black)-(1-black)*yellow;

        return (red: red, green: green, blue: blue)
    }
    

    static func cmykBlend(colors: [UIColor]) -> UIColor {
        if (colors.count == 0) {
            return UIColor.whiteColor()
        }

        if (colors.count == 1) {
            return colors[0]
        }
        
        var cyan: CGFloat = 0;
        var magenta: CGFloat = 0;
        var yellow: CGFloat = 0;
        var black: CGFloat = 0;
        
        for color in colors {
            var r: CGFloat = 0;
            var g: CGFloat = 0;
            var b: CGFloat = 0;
            color.getRed(&r, green: &g, blue: &b, alpha: nil);
            
            let cmyk = rgbToCmyk(red: r, green: g, blue: b)
            cyan += cmyk.cyan;
            magenta += cmyk.magenta
            yellow += cmyk.yellow
            black += cmyk.black
        }
        
        cyan = cyan / sqrt(CGFloat(colors.count) - 1)
        magenta = magenta / sqrt(CGFloat(colors.count) - 1)
        yellow = yellow / sqrt(CGFloat(colors.count) - 1)
        black = black / sqrt(sqrt(CGFloat(colors.count)))
        
        let rgb = cmykToRgb(cyan: cyan, magenta: magenta, yellow: yellow, black: black)
        return UIColor.init(red: rgb.red, green: rgb.green, blue: rgb.blue, alpha: 1.0)
    }
    
    static func roundToPlaces(value value:CGFloat, places:Int) -> CGFloat {
        let divisor = pow(10.0, CGFloat(places))
        return round(value * divisor) / divisor
    }
    
    static func hsvBlend(colors: [UIColor]) -> UIColor {
        if (colors.count == 0) {
            return UIColor.whiteColor()
        }
        
        var hue: CGFloat = 0
        var sat: CGFloat = 0
        var val: CGFloat = 0
        
        var x: CGFloat = 0
        var y: CGFloat = 0
        
        let pi2: CGFloat = 3.14159 * 2;
        
        var hues: CGFloat = 0;
        var whites: CGFloat = 0;
        
        for color in colors {
            var h: CGFloat = 0
            var s: CGFloat = 0
            var v: CGFloat = 0
            
            color.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
            
            if (h != 0) {
                hues += 1;
                x += cos(pi2 * h)
                y += sin(pi2 * h)
                sat += s

            } else if (v == 1.0) {
                whites += 1;
            }

            val += v
        }
        
        sat = (sat) / (hues + whites)
        val = val / CGFloat(colors.count)
        
        if (x != 0.0 || y != 0.0) {
            hue = atan2(y, x)
            while (hue < 0) {
                hue += pi2
            }
            hue = hue / pi2
        } else {
            sat = 0
        }

        return UIColor.init(hue: hue, saturation: sat, brightness: val, alpha: 1.0)
    }

    static func getHueDegrees(color: UIColor) -> Int {
        var h: CGFloat = 0;
        var s: CGFloat = 0;
        var v: CGFloat = 0;
        color.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
        return Int(h * 360)
    }
    
    static let PrimaryHues = [
        0: Constants.Palette.red,
        30: Constants.Palette.yellow,
        60: Constants.Palette.yellow,
        90: Constants.Palette.green,
        120: Constants.Palette.green,
        150: Constants.Palette.cyan,
        180: Constants.Palette.cyan,
        210: Constants.Palette.blue,
        240: Constants.Palette.blue,
        270: Constants.Palette.magenta,
        300: Constants.Palette.magenta,
        330: Constants.Palette.red,
        360: Constants.Palette.red,
        ];

    // Figure out the nearest primary color based on the hue of the given color.
    // Use a simple static map by rounding the hue to the nearest 30 degrees
    static func closestPrimaryColor(color: UIColor) -> UIColor {
        let hue = getHueDegrees(color);

        let primaryHue = (hue / 30) * 30;
        return PrimaryHues[primaryHue]!
    }
    
    // Given a color, return the blend of primary colors that will produce the blend
    static func hsvUnblend(color: UIColor) -> [UIColor] {
        var hueX: CGFloat = 0;
        var sat: CGFloat = 0;
        var val: CGFloat = 0;
        color.getHue(&hueX, saturation: &sat, brightness: &val, alpha: nil)

        let hue = getHueDegrees(color)
        
        // Initialize with the closest primary color.
        var colors: [UIColor] = [closestPrimaryColor(color)];

        // Then loop over by adding the next closest primary hues, either above or below.
        let lower = PrimaryHues[(hue / 60) * 60]!
        let upper = PrimaryHues[((hue + 59) / 60) * 60]!
        for _ in 1...100 {
            let hue2 = getHueDegrees(hsvBlend(colors))
            let delta = abs(hue - hue2);
            if (delta == 0) {
                print("matched hue \(hue)")
                break // all done
            }
            
            if (hue < hue2) {
                print("hue \(hue) current \(hue2) adding lower \(getHueDegrees(lower))")
                colors.append(lower)
            } else {
                print("hue \(hue) current \(hue2) adding upper \(getHueDegrees(upper))")
                colors.append(upper)
            }

            let hue3 = getHueDegrees(hsvBlend(colors))
            let delta2 = abs(hue - hue3)
            if (hue3 == hue2 || (delta2 > delta && delta2 < 5) || (delta2 == delta && delta2 == 1)) {
                print("last color didn't improve hue \(hue2) -> \(hue3) -- removing")
                colors.popLast()
                break
            }

        }
        
        var hueColors: [UIColor] = [];
        for hueColor in colors {
            hueColors.append(hueColor)
        }
        
        // Next, add some white to drop down the saturation as needed
        for _ in 1...100 {
            var h: CGFloat = 0;
            var s: CGFloat = 0;
            var v: CGFloat = 0;
            
            let blendedColor = hsvBlend(colors)
            blendedColor.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
            
            if (abs(s - sat) <= 0.01) {
                print("matched sat \(sat)")
                break
            }
            
            if (s > sat) {
                print("sat \(sat) current \(s) adding white")
                colors.append(Constants.Palette.white)
            } else {
                print("sat \(sat) current \(s) need more color")
                for hueColor in hueColors {
                    colors.append(hueColor)
                }
                break
            }
        }

        // Finally, add some black to drop down the value as needed
        for _ in 1...100 {
            var h: CGFloat = 0;
            var s: CGFloat = 0;
            var v: CGFloat = 0;
            
            let blendedColor = hsvBlend(colors)
            blendedColor.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
            
            if (abs(v - val) <= 0.01) {
                print("matched val \(val)")
                break
            }
            
            if (v > val) {
                print("val \(val) current \(v) adding black")
                colors.append(Constants.Palette.black)
            } else {
                print("ERROR! val \(val) current \(v) need more color")
                break
            }
        }
        
        func describe(color: UIColor) -> String {
            var h: CGFloat = 0;
            var s: CGFloat = 0;
            var v: CGFloat = 0;
            color.getHue(&h, saturation: &s, brightness: &v, alpha: nil)
            
            let name = ColorName.closestMatch(color);
            let colorStr = "[\(name) \(String(Int(h * 360))) \(String(Int(s * 100))) \(String(Int(v * 100)))]";
            return colorStr;
        }
        
        print("unblend done \(describe(color)) => \(describe(hsvBlend(colors)))")
        
        return colors;
    }
}