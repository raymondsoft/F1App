import SwiftUI

public extension F1UI.Qualifying {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let position: Int?
            public let driverName: String
            public let constructorName: String
            public let q1Text: String?
            public let q2Text: String?
            public let q3Text: String?
            public let teamStyleToken: TeamStyleToken?
            public let teamShortCode: String?

            public init(
                id: String,
                positionText: String,
                position: Int? = nil,
                driverName: String,
                constructorName: String,
                q1Text: String?,
                q2Text: String?,
                q3Text: String?,
                teamStyleToken: TeamStyleToken? = nil,
                teamShortCode: String? = nil
            ) {
                self.id = id
                self.positionText = positionText
                self.position = position
                self.driverName = driverName
                self.constructorName = constructorName
                self.q1Text = q1Text
                self.q2Text = q2Text
                self.q3Text = q3Text
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
                HStack(spacing: F1Theme.Spacing.s) {
                    if let token = viewData.teamStyleToken {
                        F1UI.TeamStripe(.init(token: token))
                            .frame(height: 28)
                    }
                    F1UI.PositionBadge(
                        .init(
                            position: viewData.position,
                            text: "P\(viewData.positionText)"
                        )
                    )
                }
            } content: {
                VStack(alignment: .leading, spacing: F1Theme.Spacing.xs) {
                    Text(viewData.driverName)
                        .font(F1Theme.Typography.rowTitle)
                        .foregroundStyle(F1Theme.Colors.textPrimary)

                    Text(viewData.constructorName)
                        .font(F1Theme.Typography.rowSubtitle)
                        .foregroundStyle(F1Theme.Colors.textSecondary)
                }
            } trailing: {
                VStack(alignment: .trailing, spacing: F1Theme.Spacing.xs) {
                    HStack(spacing: F1Theme.Spacing.xs) {
                        lapChip(label: "Q1", value: viewData.q1Text)
                        lapChip(label: "Q2", value: viewData.q2Text)
                        lapChip(label: "Q3", value: viewData.q3Text)
                    }

                    if let shortCode = viewData.teamShortCode {
                        Text(shortCode)
                            .font(F1Theme.Typography.meta.monospacedDigit())
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            }
        }

        private func lapChip(label: String, value: String?) -> some View {
            F1UI.Chip(
                .init(
                    text: "\(label) \(value ?? "-")",
                    style: value == nil ? .neutral : .time
                )
            )
        }
    }
}

#Preview("Qualifying Row Light") {
    F1UI.Qualifying.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            position: 1,
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            q1Text: "1:29.421",
            q2Text: "1:29.374",
            q3Text: "1:29.179",
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Qualifying Row Dark") {
    F1UI.Qualifying.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            position: 1,
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            q1Text: "1:29.421",
            q2Text: "1:29.374",
            q3Text: "1:29.179",
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
