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
    var _lineLimit: Int

    @State private var expanded = false

    var body: some View {
        VStack {
            Text(text)
                .lineLimit(expanded ? nil : _lineLimit)
                // TODO add animate gradient mask
                .modifier(GradientMaskModifier(applyMask: !expanded))
                .onTapGesture {
                    expanded.toggle()
                }
                // Prevent extra space when expanded
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    init(_ text: String) {
        self.text = text
        self._lineLimit = -1
    }

    func lineLimit(_ limit: Int) -> some View {
        var copy = self
        copy._lineLimit = limit
        return copy
    }
}
