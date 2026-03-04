import SwiftUI

public extension F1UI.Driver {
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
            F1UI.RowContainer {
                Image(systemName: "person.fill")
                    .font(F1Theme.Typography.meta)
                    .foregroundStyle(F1Theme.Colors.f1Red)
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.name)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(viewData.nationality)
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
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

#Preview("Driver Row Light") {
    F1UI.Driver.Row(
        .init(
            id: "max_verstappen",
            name: "Max Verstappen",
            nationality: "Dutch",
            showsWikipediaIndicator: true
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Driver Row Dark") {
    F1UI.Driver.Row(
        .init(
            id: "max_verstappen",
            name: "Max Verstappen",
            nationality: "Dutch",
            showsWikipediaIndicator: true
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
