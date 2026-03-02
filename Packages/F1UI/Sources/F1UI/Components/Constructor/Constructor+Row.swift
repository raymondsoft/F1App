import SwiftUI

public extension F1UI.Constructor {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let name: String
            public let nationality: String
            public let showsWikipediaIndicator: Bool

            public init(
                id: String,
                name: String,
                nationality: String,
                showsWikipediaIndicator: Bool
            ) {
                self.id = id
                self.name = name
                self.nationality = nationality
                self.showsWikipediaIndicator = showsWikipediaIndicator
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewData.name)
                        .font(.headline)

                    Text(viewData.nationality)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

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

#Preview("Constructor Row") {
    F1UI.Constructor.Row(
        .init(
            id: "red_bull",
            name: "Red Bull Racing",
            nationality: "Austrian",
            showsWikipediaIndicator: true
        )
    )
    .padding()
}
