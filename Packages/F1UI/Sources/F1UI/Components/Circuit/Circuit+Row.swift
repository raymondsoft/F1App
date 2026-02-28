import SwiftUI

public extension F1UI.Circuit {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let name: String
            public let locality: String
            public let country: String
            public let showsWikipediaIndicator: Bool

            public init(
                id: String,
                name: String,
                locality: String,
                country: String,
                showsWikipediaIndicator: Bool
            ) {
                self.id = id
                self.name = name
                self.locality = locality
                self.country = country
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

                    Text("\(viewData.locality), \(viewData.country)")
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

#Preview("Circuit Row") {
    F1UI.Circuit.Row(
        .init(
            id: "silverstone",
            name: "Silverstone Circuit",
            locality: "Silverstone",
            country: "United Kingdom",
            showsWikipediaIndicator: true
        )
    )
    .padding()
}

#Preview("Circuit Row Without Wikipedia") {
    F1UI.Circuit.Row(
        .init(
            id: "monaco",
            name: "Circuit de Monaco",
            locality: "Monte-Carlo",
            country: "Monaco",
            showsWikipediaIndicator: false
        )
    )
    .padding()
}
