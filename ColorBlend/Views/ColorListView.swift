//
//  ColorListView.swift
//  ColorBlend
//
//  Created by Michael Demmer on 7/14/16.
//  Copyright © 2016 Michael Demmer. All rights reserved.
//

import SwiftUI

/// A searchable list of every named color. Picking one shows how to blend it.
struct ColorListView: View {
    let onSelect: (String) -> Void
    let onRandom: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var search = ""

    private var colors: [ColorName] {
        if search.isEmpty {
            return ColorName.sortedByHue
        }
        return ColorName.sortedByHue.filter { $0.name.localizedCaseInsensitiveContains(search) }
    }

    var body: some View {
        NavigationStack {
            List(colors) { spec in
                Button {
                    onSelect(spec.name)
                    dismiss()
                } label: {
                    HStack(spacing: 12) {
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(uiColor: spec.color))
                            .strokeBorder(.secondary, lineWidth: 0.5)
                            .frame(width: 30, height: 30)
                        Text(spec.name)
                    }
                }
                .tint(.primary)
            }
            .listStyle(.plain)
            .searchable(text: $search, placement: .navigationBarDrawer(displayMode: .always))
            .navigationTitle("Select Color")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Random") {
                        onRandom()
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    ColorListView(onSelect: { _ in }, onRandom: {})
}
