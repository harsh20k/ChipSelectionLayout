//
//  ChipsView.swift
//  ChipSelectionLayout
//
//  Created by harsh  on 13/03/25.
//

import SwiftUI

struct ChipsView<Content: View, Tag: Equatable>: View where Tag: Hashable {
	var spacing: CGFloat = 10
	var animation : Animation = .easeInOut(duration: 0.2)
	var tags: [Tag]
	@ViewBuilder var content: (Tag, Bool) -> Content
	var didChangeSelection: ([Tag]) -> ()
	/// View Properties
	@State private var selectedTags: [Tag] = []
    var body: some View {
		CustomChipLayout(spacing: spacing) {
			ForEach(tags, id: \.self) { tag in
				content(tag, selectedTags.contains(tag))
					.contentShape(.rect)
					.onTapGesture {
						withAnimation(animation) {
							if selectedTags.contains(tag) {
								selectedTags.removeAll { $0 == tag }
							} else {
								selectedTags.append(tag)
							}
						}
						
						/// Callback after update:
						didChangeSelection(selectedTags)
					}
			}
		}
    }
}

/// Custom CHIP UI
fileprivate struct CustomChipLayout: Layout {
	var spacing: CGFloat
	func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
		/// Allocates all the space to the chips View
		/// return proposal.replacingUnspecifiedDimensions()
		let width = proposal.width ?? 0
		return .init(width: width, height: maxHeight(proposal: proposal, subviews: subviews))
	}
	
//	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
//		var origin = bounds.origin
//		var row: CGFloat = 1.0		//Tracks the row number
//		
//		for subview in subviews {
//			let fitSize = subview.sizeThatFits(proposal)
//			
//			if origin.x + fitSize.width > bounds.maxX  {
//				row += 1
//				origin.x = bounds.minX + 2 * row * spacing
//				origin.y += fitSize.height + spacing
//				
//				subview.place(at: origin, proposal: proposal)
//				origin.x += fitSize.width + spacing
//			} else {
//				subview.place(at: origin, proposal: proposal)
//				origin.x += fitSize.width + spacing
//			}
//		}
//	}
	
	func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
		var origin = bounds.origin
		var row: Int = 1
		var elementsInRow = 2  // Alternating 2 and 3 elements per row
		var elementsPlaced = 0
		
		let totalElements = subviews.count
		let minRows = 3  // Ensure at least 3 rows
		
			// Adjust element distribution to ensure at least 3 rows
		let estimatedRows = max(minRows, (totalElements / 3) + (totalElements % 3 == 0 ? 0 : 1))
		
		for subview in subviews {
			let fitSize = subview.sizeThatFits(proposal)
			
				// Calculate row width based on elements per row
			let rowElements = (row % 2 == 0) ? 3 : 2
			let totalRowWidth = (CGFloat(rowElements) * fitSize.width) + (CGFloat(rowElements - 1) * spacing)
			let rowStartX = (bounds.width - totalRowWidth) / 2  // Center the row
			
			if elementsPlaced >= elementsInRow {
				row += 1
				elementsInRow = (row % 2 == 0) ? 3 : 2
				elementsPlaced = 0
				origin.x = rowStartX  // Center new row
				origin.y += fitSize.height + spacing  // Move down
			}
			
				// Place the chip at the computed position
			subview.place(at: origin, proposal: proposal)
			origin.x += fitSize.width + spacing
			elementsPlaced += 1
		}
	}
	
//	private func maxHeight(proposal: ProposedViewSize, subviews: Subviews) -> CGFloat {
//		var origin: CGPoint = .zero
//		var row: CGFloat = 1.0		//Tracks the row number
//
//		for subview in subviews {
//			let fitSize = subview.sizeThatFits(proposal)
//			
//			if origin.x + fitSize.width > (proposal.width ?? 0) {
//				row += 1  // Move to next row
//
//				origin.x = 2 * row * spacing
//				origin.y += fitSize.height + spacing
//				
//				origin.x += fitSize.width + spacing
//			} else {
//				origin.x += fitSize.width + spacing
//			}
//			
//			if subview == subviews.last! {
//				origin.y += fitSize.height
//			}
//		}
//		return origin.y
//	}
	
	private func maxHeight(proposal: ProposedViewSize, subviews: Subviews) -> CGFloat {
		var origin: CGPoint = .zero
		var row: Int = 1  // Tracks the row number
		var elementsInRow = 2  // Alternates between 2 and 3 elements per row
		var elementsPlaced = 0  // Elements in current row
		
		let totalElements = subviews.count
		let minRows = 3  // Ensure at least 3 rows
		
			// Compute minimum required rows to fit all elements
		let estimatedRows = max(minRows, (totalElements / 3) + (totalElements % 3 == 0 ? 0 : 1))
		
		for subview in subviews {
			let fitSize = subview.sizeThatFits(proposal)
			
				// Determine elements per row (alternating pattern: 2, 3, 2, 3...)
			let rowElements = (row % 2 == 0) ? 3 : 2
			let totalRowWidth = (CGFloat(rowElements) * fitSize.width) + (CGFloat(rowElements - 1) * spacing)
			let rowStartX = ((proposal.width ?? 0) - totalRowWidth) / 2  // Center the row
			
			if elementsPlaced >= elementsInRow {
				row += 1  // Move to next row
				elementsInRow = (row % 2 == 0) ? 3 : 2  // Update row pattern
				elementsPlaced = 0  // Reset count
				origin.x = rowStartX  // Center row horizontally
				origin.y += fitSize.height + spacing  // Move down
			}
			
				// Increment count for elements placed in row
			elementsPlaced += 1
		}
		
			// Ensure height accounts for last row
		if let lastSubview = subviews.last {
			origin.y += lastSubview.sizeThatFits(proposal).height
		}
		
		return origin.y
	}
}

#Preview {
    ContentView()
}
