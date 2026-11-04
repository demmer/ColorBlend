//
//  LevelsView.swift
//  ColorBlend
//
//  Created by Michael Demmer on 5/28/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SwiftUI

/// The red, green and blue levels, the hue wheel, and the saturation and value
/// levels. Dragging any of them changes the blend to match.
struct LevelsView: View {
    let model: BlendModel

    var body: some View {
        HStack(spacing: 12) {
            LevelBar(title: "Red", value: model.red, tint: .red, onChange: model.setRed)
            LevelBar(title: "Green", value: model.green, tint: .green, onChange: model.setGreen)
            LevelBar(title: "Blue", value: model.blue, tint: .blue, onChange: model.setBlue)
            HueWheel(hue: model.hue, showsNeedle: model.saturation > 0, onChange: model.setHue)
                .padding(.horizontal, 8)
            LevelBar(title: "Sat", value: model.saturation, tint: .primary, onChange: model.setSaturation)
            LevelBar(title: "Val", value: model.brightness, tint: .primary, onChange: model.setBrightness)
        }
    }
}

struct LevelBar: View {
    let title: String
    let value: CGFloat
    let tint: Color
    let onChange: (CGFloat) -> Void

    var body: some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Rectangle()
                        .strokeBorder(tint, lineWidth: 1)
                    Rectangle()
                        .fill(tint)
                        .frame(height: geometry.size.height * value)
                }
                .contentShape(.rect)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            onChange(min(1, max(0, 1 - drag.location.y / geometry.size.height)))
                        }
                )
            }
            .frame(minWidth: 18, maxWidth: 34)
            Text("\(Int(value * 100))%")
                .font(.caption)
                .monospacedDigit()
                .fixedSize()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(title)
        .accessibilityValue("\(Int(value * 100)) percent")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: onChange(min(1, value + 0.1))
            case .decrement: onChange(max(0, value - 0.1))
            @unknown default: break
            }
        }
    }
}

struct HueWheel: View {
    let hue: CGFloat
    let showsNeedle: Bool
    let onChange: (CGFloat) -> Void

    var body: some View {
        VStack(spacing: 4) {
            Text("Hue")
                .font(.caption)
            GeometryReader { geometry in
                let radius = min(geometry.size.width, geometry.size.height) / 2
                let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
                ZStack {
                    // Hue increases counterclockwise from the right, so the
                    // gradient (which runs clockwise) goes from 1 down to 0.
                    Circle()
                        .fill(AngularGradient(
                            colors: (0...12).map { Color(hue: 1 - Double($0) / 12, saturation: 1, brightness: 1) },
                            center: .center))
                        .overlay {
                            Circle().fill(RadialGradient(
                                colors: [.white, .white.opacity(0)], center: .center, startRadius: 0, endRadius: radius))
                        }
                        .frame(width: radius * 2, height: radius * 2)
                    if showsNeedle {
                        Path { path in
                            let angle = 2 * .pi * hue
                            path.move(to: center)
                            path.addLine(to: CGPoint(x: center.x + radius * cos(angle), y: center.y - radius * sin(angle)))
                        }
                        .stroke(.black, lineWidth: 2)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .contentShape(.rect)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { drag in
                            var newHue = atan2(center.y - drag.location.y, drag.location.x - center.x) / (2 * .pi)
                            if newHue < 0 {
                                newHue += 1
                            }
                            onChange(newHue)
                        }
                )
            }
            .frame(minWidth: 60)
            Text("\(Int(hue * 360))°")
                .font(.caption)
                .monospacedDigit()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel("Hue")
        .accessibilityValue("\(Int(hue * 360)) degrees")
        .accessibilityAdjustableAction { direction in
            switch direction {
            case .increment: onChange((hue + 15 / 360).truncatingRemainder(dividingBy: 1))
            case .decrement: onChange((hue + 345 / 360).truncatingRemainder(dividingBy: 1))
            @unknown default: break
            }
        }
    }
}
