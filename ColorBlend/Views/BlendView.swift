//
//  BlendView.swift
//  ColorBlend
//
//  Created by Michael Demmer on 4/12/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SwiftUI

/// The main screen: the blend's name and levels, the canvas, and the palette.
struct BlendView: View {
    @State private var model = BlendModel()
    @State private var showingColorList = false
    @State private var canvasFrame: CGRect = .zero
    @State private var dragged: Paint?
    @State private var flights: [Flight] = []
    @Environment(\.horizontalSizeClass) private var sizeClass

    /// A paint being dragged around the screen.
    struct Paint {
        var color: UIColor
        var size: CGSize
        var location: CGPoint
    }

    /// A tapped paint on its way to the canvas.
    struct Flight: Identifiable {
        let id = UUID()
        var paint: Paint
    }

    var body: some View {
        VStack(spacing: 20) {
            Text(model.blendName ?? "Tap Colors To Blend")
                .font(.title.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.5)

            LevelsView(model: model)
                .frame(height: sizeClass == .regular ? 280 : 170)

            canvas

            PaletteView(model: model, actions: paletteActions)
        }
        .padding()
        .frame(maxWidth: 700)
        .coordinateSpace(.named(BlendView.space))
        .overlay { movingPaints }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: model.colors.count)
        .sheet(isPresented: $showingColorList) {
            ColorListView(onSelect: model.show(named:), onRandom: model.showRandomColor)
        }
    }

    nonisolated static let space = "board"

    private var canvas: some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(Color(uiColor: model.blend ?? .white))
            .strokeBorder(.primary, lineWidth: 1)
            .overlay(alignment: .bottom) {
                if model.blend == nil {
                    Label("Tap to pick a named color", systemImage: "eyedropper")
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        .padding()
                }
            }
            .animation(.easeInOut(duration: 0.2), value: model.blend)
            .onGeometryChange(for: CGRect.self) { $0.frame(in: .named(BlendView.space)) } action: { canvasFrame = $0 }
            .contentShape(.rect)
            .onTapGesture { showingColorList = true }
            .accessibilityElement()
            .accessibilityLabel("Blend")
            .accessibilityValue(model.blendName ?? "Empty")
            .accessibilityHint("Choose a named color to see how to mix it")
            .accessibilityAddTraits(.isButton)
    }

    private var movingPaints: some View {
        ZStack {
            ForEach(flights) { flight in
                FlyingPaint(paint: flight.paint, destination: CGPoint(x: canvasFrame.midX, y: canvasFrame.midY)) {
                    flights.removeAll { $0.id == flight.id }
                    model.add(flight.paint.color)
                }
            }
            if let dragged {
                PaintShape(color: dragged.color)
                    .frame(width: dragged.size.width, height: dragged.size.height)
                    .position(dragged.location)
            }
        }
        .allowsHitTesting(false)
    }

    private var paletteActions: PaletteView.Actions {
        PaletteView.Actions(
            tap: { color, frame in
                let start = CGPoint(x: frame.midX, y: frame.midY)
                flights.append(Flight(paint: Paint(color: color, size: frame.size, location: start)))
            },
            drag: { color, frame, location in
                dragged = Paint(color: color, size: frame.size, location: location)
            },
            drop: { color, location in
                if canvasFrame.contains(location) {
                    model.add(color)
                }
                dragged = nil
            },
            reset: model.reset
        )
    }
}

/// Animates a copy of a paint from where it was tapped to the canvas.
private struct FlyingPaint: View {
    let paint: BlendView.Paint
    let destination: CGPoint
    let onArrival: () -> Void
    @State private var arrived = false

    var body: some View {
        PaintShape(color: paint.color)
            .frame(width: paint.size.width, height: paint.size.height)
            .position(arrived ? destination : paint.location)
            .onAppear {
                withAnimation(.easeIn(duration: 0.25)) {
                    arrived = true
                } completion: {
                    onArrival()
                }
            }
    }
}

#Preview {
    BlendView()
}
