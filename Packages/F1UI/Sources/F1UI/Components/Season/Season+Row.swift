import SwiftUI

public extension F1UI.Season {
    struct Row: View {
        public struct Data: Hashable, Sendable {
            public let title: String
            public let showsWikipediaIndicator: Bool

            public init(title: String, showsWikipediaIndicator: Bool) {
                self.title = title
                self.showsWikipediaIndicator = showsWikipediaIndicator
            }
        }

        private let data: Data

        public init(data: Data) {
            self.data = data
        }

        public var body: some View {
            HStack(spacing: 12) {
                Text(data.title)
                    .font(.headline)

                Spacer(minLength: 0)

                if data.showsWikipediaIndicator {
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
        data: .init(
            title: "2024",
            showsWikipediaIndicator: true
        )
    )
    .padding()
}
