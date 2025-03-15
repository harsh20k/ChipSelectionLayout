//
//  ContentView.swift
//  ChipSelectionLayout
//
//  Created by harsh  on 13/03/25.
//

import SwiftUI

/// Sample Data
let tags: [String] = ["IOS 14", "SwiftUI", "macOS", "watchOS", "tvOS", "Xcode", "AppKit", "Cocoa", "Python", "IOS", "C++", "Objective-C", "Go", "R", "SQL", "DBMS"]

struct ContentView: View {
    var body: some View {
		NavigationStack {
			VStack {
				ChipsView(tags: tags) { tag, isSelected in
					/// Your Custom View
					ChipView(tag, isSelected: isSelected)
					
				} didChangeSelection: { selection in
					print(selection)
				}
				.padding(10)
				.background(.gray.opacity(0.1), in: .rect(cornerRadius: 20))
			}
			.padding(15)
			.navigationTitle("Chips Selection")
		}
    }
	
	@ViewBuilder
	func ChipView(_ tag: String, isSelected: Bool) -> some View {
		HStack(spacing: 10) {
			Text(tag)
				.font(.callout)
				.foregroundStyle(isSelected ? .white : Color.primary)
			
			if isSelected {
				Image(systemName: "checkmark.circle.fill")
					.foregroundStyle(.white)
			}
		}
		.padding(.horizontal, 12)
		.padding(.vertical, 8)
		.background {
			ZStack {
				Capsule()
					.fill(.background)
					.opacity(!isSelected ? 1 : 0)
				
				Capsule()
					.fill(.green.gradient)
					.opacity(isSelected ? 1 : 0)
			}
		}
	}
}

#Preview {
    ContentView()
}
