//
//  PaletteView.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SwiftUI

/// The paints, each showing how many of it are in the blend, plus the reset button.
struct PaletteView: View {
    let model: BlendModel
    let actions: Actions

    struct Actions {
        /// A paint was tapped; its frame is in the board's coordinate space.
        var tap: (UIColor, CGRect) -> Void
        /// A paint is being dragged to the given location.
        var drag: (UIColor, CGRect, CGPoint) -> Void
        /// A dragged paint was let go at the given location.
        var drop: (UIColor, CGPoint) -> Void
        var reset: () -> Void
    }

    var body: some View {
        Grid(horizontalSpacing: 10, verticalSpacing: 16) {
            ForEach(Palette.rows.indices, id: \.self) { row in
                GridRow {
                    ForEach(Palette.rows[row].indices, id: \.self) { column in
                        if let color = Palette.rows[row][column] {
                            PaintSlot(color: color, count: model.count(of: color), actions: actions)
                        } else {
                            resetButton
                        }
                    }
                }
            }
        }
    }

    private var resetButton: some View {
        Button(action: actions.reset) {
            VStack(spacing: 4) {
                Image(systemName: "arrow.counterclockwise.circle")
                    .resizable()
                    .scaledToFit()
                    .fontWeight(.light)
                Text("Reset")
                    .font(.caption)
            }
        }
        .tint(.primary)
    }
}

private struct PaintSlot: View {
    let color: UIColor
    let count: Int
    let actions: PaletteView.Actions
    @State private var frame: CGRect = .zero

    var body: some View {
        VStack(spacing: 4) {
            PaintShape(color: color)
                .aspectRatio(1 / 1.3, contentMode: .fit)
                .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(BlendView.space)) } action: { frame = $0 }
                .onTapGesture { actions.tap(color, frame) }
                .gesture(
                    DragGesture(minimumDistance: 8, coordinateSpace: .named(BlendView.space))
                        .onChanged { actions.drag(color, frame, $0.location) }
                        .onEnded { actions.drop(color, $0.location) }
                )
            Text(count > 0 ? "\(count)" : " ")
                .font(.caption)
                .monospacedDigit()
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(ColorName.closestMatch(color))
        .accessibilityValue(count > 0 ? "\(count) in blend" : "")
        .accessibilityHint("Adds this paint to the blend")
        .accessibilityAddTraits(.isButton)
        .accessibilityAction { actions.tap(color, frame) }
    }
}

struct PaintShape: View {
    let color: UIColor

    var body: some View {
        Ellipse()
            .fill(Color(uiColor: color))
            .strokeBorder(.primary.opacity(0.7), lineWidth: 1)
    }
}
