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
            F1UI.RowContainer {
                Image(systemName: "calendar")
                    .font(F1Theme.Typography.meta)
                    .foregroundStyle(F1Theme.Colors.f1Red)
            } content: {
                Text(viewData.title)
                    .font(F1Theme.Typography.rowTitle.monospacedDigit())
                    .foregroundStyle(F1Theme.Colors.textPrimary)
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

#Preview("Season Row") {
    F1UI.Season.Row(
        .init(
            id: "2024",
            title: "2024",
            showsWikipediaIndicator: true
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
}
