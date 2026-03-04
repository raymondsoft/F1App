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
            F1UI.RowContainer {
                Image(systemName: "map")
                    .font(F1Theme.Typography.meta)
                    .foregroundStyle(F1Theme.Colors.f1Red)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.name)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text("\(viewData.locality), \(viewData.country)")
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                        .accessibilityLabel("\(viewData.locality), \(viewData.country)")
                }
            } trailing: {
                if viewData.showsWikipediaIndicator {
                    Label("Wikipedia", systemImage: "link")
                        .font(F1Theme.Typography.meta.weight(.semibold))
                        .labelStyle(.iconOnly)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                        .accessibilityLabel("Wikipedia available")
                }
            }
        }
    }
}

#Preview("Circuit Row Light") {
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
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Circuit Row Dark") {
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
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
