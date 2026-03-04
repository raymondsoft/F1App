import SwiftUI

public extension F1UI.Constructor {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let name: String
            public let nationality: String
            public let showsWikipediaIndicator: Bool
            public let teamStyleToken: TeamStyleToken?
            public let teamShortCode: String?

            public init(
                id: String,
                name: String,
                nationality: String,
                showsWikipediaIndicator: Bool,
                teamStyleToken: TeamStyleToken? = nil,
                teamShortCode: String? = nil
            ) {
                self.id = id
                self.name = name
                self.nationality = nationality
                self.showsWikipediaIndicator = showsWikipediaIndicator
                self.teamStyleToken = teamStyleToken
                self.teamShortCode = teamShortCode
            }
        }

        private let viewData: ViewData

        public init(_ viewData: ViewData) {
            self.viewData = viewData
        }

        public var body: some View {
            F1UI.RowContainer {
                if let token = viewData.teamStyleToken {
                    F1UI.TeamStripe(.init(token: token))
                        .frame(height: 28)
                } else {
                    Image(systemName: "car.rear")
                        .font(F1Theme.Typography.meta)
                        .foregroundStyle(F1Theme.Colors.f1Red)
                }
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
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    if let shortCode = viewData.teamShortCode {
                        Text(shortCode)
                            .font(F1Theme.Typography.timing)
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
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
}

#Preview("Constructor Row Light") {
    F1UI.Constructor.Row(
        .init(
            id: "red_bull",
            name: "Red Bull Racing",
            nationality: "Austrian",
            showsWikipediaIndicator: true,
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Constructor Row Dark") {
    F1UI.Constructor.Row(
        .init(
            id: "red_bull",
            name: "Red Bull Racing",
            nationality: "Austrian",
            showsWikipediaIndicator: true,
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
