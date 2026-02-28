import SwiftUI

public extension F1UI.Season {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let title: String
            public let showsWikipediaIndicator: Bool

            public init(id: String, title: String, showsWikipediaIndicator: Bool) {
                self.id = id
                self.title = title
                self.showsWikipediaIndicator = showsWikipediaIndicator
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            HStack(spacing: 12) {
                Text(viewData.title)
                    .font(.headline)

                Spacer(minLength: 0)

                if viewData.showsWikipediaIndicator {
                    Label("Wikipedia", systemImage: "link")
                        .font(.caption.weight(.semibold))
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel("Wikipedia available")
                }
            }
            .padding(.vertical, 4)
        }
    }
}

#Preview("Season Row") {
    F1UI.Season.Row(
        .init(
            id: "2024",
            title: "2024",
            showsWikipediaIndicator: true
        )
    )
    .padding()
}
