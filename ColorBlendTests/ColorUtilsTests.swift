//
//  ColorUtilsTests.swift
//  ColorBlendTests
//
//  Created by Michael Demmer on 5/25/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import Testing
import UIKit
@testable import ColorBlend

struct ColorNameTests {
    @Test func closestMatch() {
        #expect(ColorName.closestMatch(.black) == "Black")
        #expect(ColorName.closestMatch(.white) == "White")
        #expect(ColorName.closestMatch(.blue) == "Blue")
        #expect(ColorName.closestMatch(.red) == "Red")
        #expect(ColorName.closestMatch(.green) == "Green")
        #expect(ColorName.closestMatch(.cyan) == "Cyan")
        #expect(ColorName.closestMatch(.magenta) == "Magenta")
        #expect(ColorName.closestMatch(.orange) == "Orange")
        #expect(ColorName.closestMatch(.brown) == "Brown")
        #expect(ColorName.closestMatch(.lightGray) == "Light gray")
        #expect(ColorName.closestMatch(.darkGray) == "Dark gray")
        #expect(ColorName.closestMatch(.purple) == "Purple")

        #expect(ColorName.closestMatch(UIColor(red: 0, green: 0.0784313725490196, blue: 0.6588235294117647, alpha: 1)) == "Zaffre")
        #expect(ColorName.closestMatch(UIColor(red: 0, green: 0.079, blue: 0.6588235294117647, alpha: 1)) == "Zaffre")
    }

    @Test func noDuplicateNames() {
        for spec in ColorName.all {
            #expect(ColorName.closestMatch(spec.color) == spec.name)
        }
    }
}

struct ColorUtilsTests {
    @Test func hsvBlend() {
        #expect(ColorName.closestMatch(ColorUtils.hsvBlend([.red])) == "Red")
        #expect(ColorName.closestMatch(ColorUtils.hsvBlend([.blue])) == "Blue")
        #expect(ColorName.closestMatch(ColorUtils.hsvBlend([.red, .blue])) == "Magenta")
        #expect(ColorName.closestMatch(ColorUtils.hsvBlend([.yellow, .blue])) == "Spring green")
        #expect(ColorName.closestMatch(ColorUtils.hsvBlend([.red, .red, .green])) == "Orange")

        // This is nonintuitive, but due to the slight rounding this is what happens.
        let neutral = ColorUtils.hsvBlend([.blue, .red, .green])
        #expect(ColorName.closestMatch(neutral) == "Blue")
    }

    @Test(arguments: [
        (0, 360), (10, 360), (29, 360),
        (30, 60), (31, 60), (65, 60), (89, 60),
        (91, 120), (149, 120),
        (150, 180), (209, 180),
        (210, 240), (269, 240),
        (270, 300), (329, 300),
        (330, 360), (359, 360), (360, 360),
    ])
    func closestPrimaryHue(hueDegrees: Int, expected: Int) {
        let color = UIColor(hue: CGFloat(hueDegrees) / 360, saturation: 1, brightness: 1, alpha: 1)
        #expect(ColorUtils.getHueDegrees(ColorUtils.closestPrimaryColor(color)) == expected)
    }

    func describe(_ colors: [UIColor]) -> String {
        colors.map { color in
            let (h, s, v) = color.hsb
            return "[\(ColorName.closestMatch(color)) \(Int(h * 360)) \(Int(s * 100)) \(Int(v * 100))]"
        }.joined(separator: " ")
    }

    @Test func hsvUnblend() {
        let red = "[Red 360 100 100]"
        let yellow = "[Yellow 60 100 100]"
        let magenta = "[Magenta 300 100 100]"
        let white = "[White 0 0 100]"
        let black = "[Black 0 0 0]"

        func parts(_ parts: [String]) -> String { parts.joined(separator: " ") }

        #expect(describe(ColorUtils.hsvUnblend(Palette.black)) == black)
        #expect(describe(ColorUtils.hsvUnblend(Palette.white)) == white)
        #expect(describe(ColorUtils.hsvUnblend(Palette.gray)) == parts([black, white, white]))
        #expect(describe(ColorUtils.hsvUnblend(Palette.red)) == red)
        #expect(describe(ColorUtils.hsvUnblend(Palette.orange)) == parts([red, yellow]))
        #expect(describe(ColorUtils.hsvUnblend(Palette.brown)) == parts([red, yellow, white, black, black]))
        #expect(describe(ColorUtils.hsvUnblend(Palette.pink)) == parts(
            Array(repeating: magenta, count: 2) + Array(repeating: red, count: 9) + Array(repeating: white, count: 33)))
    }

    /// Every named color should survive a round trip through unblend and blend.
    @Test(arguments: ColorName.all)
    func hsvUnblendRoundTrip(spec: ColorName) {
        let blend = ColorUtils.hsvBlend(ColorUtils.hsvUnblend(spec.color))
        #expect(ColorName.closestMatch(blend) == spec.name)
    }
}
