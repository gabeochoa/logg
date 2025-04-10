import Cocoa
import SwiftUI

struct GradientMaskModifier: ViewModifier {
    let applyMask: Bool

    func body(content: Content) -> some View {
        if applyMask {
            content.mask(
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: .black, location: 0.0),
                        .init(color: .black, location: 0.7),
                        .init(color: .clear, location: 1.0),
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        } else {
            content  // no mask when expanded
        }
    }
}

struct ExpandableText: View {
    let text: String
    let lineLimit: Int

    @State private var expanded = false

    var body: some View {
        ZStack {
            Text(text)
                .lineLimit(expanded ? nil : lineLimit)
                .onTapGesture {
                    expanded.toggle()
                }
                .modifier(GradientMaskModifier(applyMask: !expanded))
            // TODO add animate gradient mask
        }
    }
}
