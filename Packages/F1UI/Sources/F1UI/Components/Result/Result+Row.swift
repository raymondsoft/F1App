import SwiftUI

public extension F1UI.Result {
    struct Row: View {
        public struct ViewData: Hashable, Sendable {
            public let id: String
            public let positionText: String
            public let position: Int?
            public let driverName: String
            public let constructorName: String
            public let pointsText: String
            public let resultChip: F1UI.Chip.ViewData
            public let teamStyleToken: TeamStyleToken?
            public let teamShortCode: String?

            public init(
                id: String,
                positionText: String,
                position: Int? = nil,
                driverName: String,
                constructorName: String,
                pointsText: String,
                resultChip: F1UI.Chip.ViewData,
                teamStyleToken: TeamStyleToken? = nil,
                teamShortCode: String? = nil
            ) {
                self.id = id
                self.positionText = positionText
                self.position = position
                self.driverName = driverName
                self.constructorName = constructorName
                self.pointsText = pointsText
                self.resultChip = resultChip
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
                    Text(viewData.pointsText)
                        .font(F1Theme.Typography.number)
                        .foregroundStyle(F1Theme.Colors.textPrimary)
                    F1UI.Chip(viewData.resultChip)
                    if let teamShortCode = viewData.teamShortCode {
                        Text(teamShortCode)
                            .font(F1Theme.Typography.meta.monospacedDigit())
                            .foregroundStyle(F1Theme.Colors.textSecondary)
                    }
                }
            }
        }
    }
}

#Preview("Result Row Light") {
    F1UI.Result.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            position: 1,
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            pointsText: "25 pts",
            resultChip: .init(text: "1:31:44.742", style: .time),
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.light)
}

#Preview("Result Row Dark") {
    F1UI.Result.Row(
        .init(
            id: "2024-1-1",
            positionText: "1",
            position: 1,
            driverName: "Max Verstappen",
            constructorName: "Red Bull Racing",
            pointsText: "25 pts",
            resultChip: .init(text: "1:31:44.742", style: .time),
            teamStyleToken: .redBull,
            teamShortCode: "RBR"
        )
    )
    .padding()
    .background(F1Theme.Colors.background)
    .preferredColorScheme(.dark)
}
