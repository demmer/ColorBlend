//
//  BlendModel.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import Observation
import UIKit

/// The paints mixed so far and the color they blend to.
@Observable
final class BlendModel {
    /// Every paint added to the blend, in order.
    private(set) var colors: [UIColor] = []

    /// How many of each paint is in the blend, keyed by the paint's color name.
    private(set) var counts: [String: Int] = [:]

    /// The blended color, or nil before any paint has been added.
    private(set) var blend: UIColor?

    var blendName: String? { blend.map(ColorName.closestMatch) }

    var red: CGFloat { blend?.rgb.red ?? 0 }
    var green: CGFloat { blend?.rgb.green ?? 0 }
    var blue: CGFloat { blend?.rgb.blue ?? 0 }
    var hue: CGFloat { blend?.hsb.hue ?? 0 }
    var saturation: CGFloat { blend?.hsb.saturation ?? 0 }
    var brightness: CGFloat { blend?.hsb.brightness ?? 0 }

    func count(of paint: UIColor) -> Int {
        counts[ColorName.closestMatch(paint)] ?? 0
    }

    func add(_ color: UIColor) {
        append(color)
        updateBlend()
    }

    func reset() {
        colors.removeAll()
        counts.removeAll()
        blend = nil
    }

    /// Replace the blend with the mix of paints that produces the given color.
    func show(_ color: UIColor) {
        reset()
        ColorUtils.hsvUnblend(color).forEach(append)
        updateBlend()
    }

    func show(named name: String) {
        if let spec = ColorName.named(name) {
            show(spec.color)
        }
    }

    func showRandomColor() {
        if let spec = ColorName.all.randomElement() {
            show(spec.color)
        }
    }

    func setRed(_ value: CGFloat) {
        show(UIColor(red: value, green: green, blue: blue, alpha: 1))
    }

    func setGreen(_ value: CGFloat) {
        show(UIColor(red: red, green: value, blue: blue, alpha: 1))
    }

    func setBlue(_ value: CGFloat) {
        show(UIColor(red: red, green: green, blue: value, alpha: 1))
    }

    func setSaturation(_ value: CGFloat) {
        show(UIColor(hue: hue, saturation: value, brightness: brightness, alpha: 1))
    }

    func setBrightness(_ value: CGFloat) {
        show(UIColor(hue: hue, saturation: saturation, brightness: value, alpha: 1))
    }

    func setHue(_ value: CGFloat) {
        // A hue means nothing without some saturation and brightness, so bump
        // those up to full if they're at zero.
        let saturation = saturation == 0 ? 1 : saturation
        let brightness = brightness == 0 ? 1 : brightness
        show(UIColor(hue: value, saturation: saturation, brightness: brightness, alpha: 1))
    }

    private func append(_ color: UIColor) {
        colors.append(color)
        counts[ColorName.closestMatch(color), default: 0] += 1
    }

    private func updateBlend() {
        blend = ColorUtils.hsvBlend(colors)
    }
}
